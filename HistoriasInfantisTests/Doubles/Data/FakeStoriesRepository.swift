//
//  FakeStoriesRepository.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class FakeStoriesRepository: StoriesRepository {
    var stories = [Story]()
    var fetchAllWasCalled = false
    var fetchFavoritesWasCalled = false
    var requestNewWasCalled = false
    var shouldFetchAllFail = false
    var shouldFetchFavoritesFail = false
    var shouldGatewayFail = false
    var shouldLocalGatewayFail = false
    var serverErrorMessage = "Bad Server Response"

    func fetchAll(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        fetchAllWasCalled = true
        handler(shouldFetchAllFail ? .failure(StoriesRepositoryError.gatewayRequestFail(serverErrorMessage)) : .success(stories))
    }

    func fetchFavorites(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        fetchFavoritesWasCalled = true
        handler(shouldFetchFavoritesFail ? .failure(StoriesRepositoryError.unableToRetrieve) : .success(stories))
    }

    func requestNew(then handler: @escaping StoriesRepositoryFetchCompletionHandler) {
        requestNewWasCalled = true
        if shouldGatewayFail {
            handler(.failure(StoriesRepositoryError.gatewayRequestFail(serverErrorMessage)))
        } else if shouldLocalGatewayFail {
            handler(.failure(StoriesRepositoryError.unableToSave))
        } else {
            handler(.success(stories))
        }
    }
}
