//
//  StoriesRepositoryImplementation.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class StoriesRepositoryImplementation: StoriesRepository {
    private let storiesLocalGateway: StoriesLocalGateway!
    private let storiesGateway: StoriesGateway!
    private let eventNotifier: EventNotifier!

    init(
        storiesGateway: StoriesGateway,
        storiesLocalGateway: StoriesLocalGateway,
        eventNotifier: EventNotifier
    ) {
        self.storiesGateway = storiesGateway
        self.storiesLocalGateway = storiesLocalGateway
        self.eventNotifier = eventNotifier
    }

    func fetchAll(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        storiesLocalGateway.fetchAll { result in
            if result.isSuccess,
                let stories = try? result.dematerialize(),
                stories.count > 0 {
                handler(result)
            } else {
                self.requestNew(then: handler)
            }
        }
    }

    func requestNew(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        storiesGateway.fetchStories { [weak self] result in
            if result.isSuccess {
                let stories = try? result.dematerialize()
                self?.startSyncPersistence(stories: stories, then: handler)
            } else {
                handler(result)
            }
        }
    }

    private func startSyncPersistence(stories: [Story]?, then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        guard let stories = stories else { return }

        var favoriteIds = [Int]()
        storiesLocalGateway.fetchFavorites { [weak self] result in
            if result.isSuccess, let stories = try? result.dematerialize() {
                favoriteIds = stories.map { $0.id }
            }

            self?.clearAllStories(stories: stories, favoriteIds: favoriteIds, then: handler)
        }
    }

    private func clearAllStories(stories: [Story], favoriteIds: [Int], then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        storiesLocalGateway.clearAll { [weak self] error in
            if let error = error {
                print("Clear persistence failed.")
                handler(.failure(error))
                return
            }

            self?.reinsertStoriesWithFavorites(stories: stories, favoriteIds: favoriteIds, then: handler)
        }
    }

    private func reinsertStoriesWithFavorites(stories: [Story], favoriteIds: [Int], then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        let storiesWithFavorites = stories.map {
            Story(id: $0.id,
                  title: $0.title,
                  url: $0.url,
                  imageUrl: $0.imageUrl,
                  paragraphs: $0.paragraphs,
                  createDate: $0.createDate,
                  updateDate: $0.updateDate,
                  favorite: favoriteIds.contains($0.id))
        }

        storiesLocalGateway.insert(stories: storiesWithFavorites) { error in
            if let error = error {
                print("Insert new stories into persistence failed.")
                handler(.failure(error))
            } else {
                handler(.success(storiesWithFavorites))
            }
            self.eventNotifier.notify(notification: StoriesRepositoryNotification.didUpdateFavorites)
        }
    }

    func fetchFavorites(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        storiesLocalGateway.fetchFavorites { result in
            handler(result)
        }
    }

    func toggleFavorite(story: Story, then handler: @escaping StoriesRepositoryWriteErrorCompletionHandler) {
        storiesLocalGateway.update(storyId: story.id, favorite: !story.favorite) { error in
            if error == nil {
                self.eventNotifier.notify(notification: StoriesRepositoryNotification.didUpdateFavorites)
            }
            handler(error)
        }
    }
}
