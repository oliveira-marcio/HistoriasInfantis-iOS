//
//  FakeStoriesGateway.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class FakeStoriesGateway: StoriesGateway {
    var stories = [Story]()
    var requestWasCalled = false
    var shouldRequestFail = false

    func request(then handler: @escaping StoriesGatewayRequestCompletionHandler) {
        requestWasCalled = true
        handler(shouldRequestFail ? .failure(StoriesRepositoryError.gatewayFail) : .success(stories))
    }
}
