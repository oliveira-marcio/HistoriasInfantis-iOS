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
    var requestNewWasCalled = false
    var shouldWebGatewayFail = false
    var shouldLocalGatewayFail = false

    func fetchAll(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        fetchAllWasCalled = true
        handler(.success(stories))
    }

    func requestNew(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        requestNewWasCalled = true
        if shouldWebGatewayFail {
            handler(.failure(StoriesRepositoryError.gatewayFail))
        } else if shouldLocalGatewayFail {
            handler(.failure(StoriesRepositoryError.unableToSave))
        } else {
            handler(.success(stories))
        }
    }
}
