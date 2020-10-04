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
    var serverErrorMessage = "Bad Server Response"

    func fetchStories(then handler: @escaping StoriesGatewayRequestCompletionHandler) {
        requestWasCalled = true
        handler(shouldRequestFail ? .failure(StoriesRepositoryError.gatewayRequestFail(serverErrorMessage)) : .success(stories))
    }
}
