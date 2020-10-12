//
//  FakeStoriesLocalGateway.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class FakeStoriesLocalGateway: StoriesLocalGateway {
    var stories = [Story]()
    var updatedStories = [Story]()
    var fetchAllWasCalled = false
    var fetchFavoritesWasCalled = false
    var clearAllWasCalled = false
    var insertWasCalled = false
    var updateWasCalled = false

    var shouldFetchAllFail = false
    var shouldClearAllFail = false
    var shouldInsertFail = false
    var shouldUpdateFail = false

    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler) {
        fetchAllWasCalled = true
        handler(shouldFetchAllFail ? .failure(StoriesRepositoryError.unableToRetrieve) : .success(stories))
    }

    func fetchFavorites(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler) {
        fetchFavoritesWasCalled = true
        handler(shouldFetchAllFail ? .failure(StoriesRepositoryError.unableToRetrieve) : .success(stories))
    }

    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        clearAllWasCalled = true
        if !shouldClearAllFail {
            stories = []
        }
        handler(shouldClearAllFail ? StoriesRepositoryError.unableToSave : nil)

    }

    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        insertWasCalled = true
        if !shouldInsertFail {
            self.stories = stories
        }
        handler(shouldInsertFail ? StoriesRepositoryError.unableToSave : nil)
    }

    func update(storyId: Int, favorite: Bool, then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        updateWasCalled = true
        if !shouldUpdateFail {
            self.stories = updatedStories
        }
        handler(updateWasCalled ? StoriesRepositoryError.unableToSave : nil)
    }
}
