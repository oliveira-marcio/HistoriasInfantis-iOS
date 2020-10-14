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
    var favoriteStories = [Story]()
    var updatedStories = [Story]()
    var updatedFavoriteStories = [Story]()
    var fetchAllWasCalled = false
    var fetchFavoritesWasCalled = false
    var clearAllWasCalled = false
    var insertWasCalled = false
    var updateStoryId: Int?
    var updateFavorite: Bool?

    var shouldFetchAllFail = false
    var shouldFetchFavoritesFail = false
    var shouldClearAllFail = false
    var shouldInsertFail = false
    var shouldUpdateFail = false

    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler) {
        fetchAllWasCalled = true
        handler(shouldFetchAllFail ? .failure(StoriesRepositoryError.unableToRetrieve) : .success(stories))
    }

    func fetchFavorites(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler) {
        fetchFavoritesWasCalled = true
        handler(shouldFetchFavoritesFail ? .failure(StoriesRepositoryError.unableToRetrieve) : .success(favoriteStories))
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
        updateStoryId = storyId
        updateFavorite = favorite
        if !shouldUpdateFail {
            self.stories = updatedStories
            self.favoriteStories = updatedFavoriteStories
        }
        handler(shouldUpdateFail ? StoriesRepositoryError.unableToSave : nil)
    }
}
