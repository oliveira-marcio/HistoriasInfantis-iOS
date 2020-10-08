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
    
    func fetchAll(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        storiesLocalGateway.fetchAll { result in
            handler(result)
        }
    }

    func requestNew(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        storiesGateway.fetchStories { [weak self] result in
            if result.isSuccess {
                let stories = try? result.dematerialize()
                self?.syncPersistence(stories: stories)
            }

            handler(result)
        }
    }

    private func syncPersistence(stories: [Story]?) {
        guard let stories = stories else { return }

        storiesLocalGateway.clearAll { [weak self] error in
            if let _ = error {
                print("Clear persistence failed.")
                return
            }

            self?.storiesLocalGateway.insert(stories: stories) { error in
                if let _ = error {
                    print("Insert new stories into persistence failed.")
                }
            }
        }
    }
}
