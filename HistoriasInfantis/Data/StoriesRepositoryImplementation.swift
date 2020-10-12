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

    init(
        storiesGateway: StoriesGateway,
        storiesLocalGateway: StoriesLocalGateway
    ) {
        self.storiesGateway = storiesGateway
        self.storiesLocalGateway = storiesLocalGateway
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
                self?.syncPersistence(stories: stories, then: handler)
            } else {
                handler(result)
            }
        }
    }

    private func syncPersistence(stories: [Story]?, then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        guard let stories = stories else { return }

        storiesLocalGateway.clearAll { [weak self] error in
            if let error = error {
                print("Clear persistence failed.")
                handler(.failure(error))
                return
            }

            self?.storiesLocalGateway.insert(stories: stories) { error in
                if let error = error {
                    print("Insert new stories into persistence failed.")
                    handler(.failure(error))
                } else {
                    handler(.success(stories))
                }
            }
        }
    }

    func fetchFavorites(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        storiesLocalGateway.fetchFavorites { result in
            handler(result)
        }
    }

    func toggleFavorite(story: Story, then handler: @escaping StoriesRepositoryWriteErrorCompletionHandler) {
        storiesLocalGateway.update(storyId: story.id, favorite: !story.favorite) { result in
            handler(result)
        }
    }
}
