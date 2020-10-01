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
    var fetchAllWasCalled = false

    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler) {
        fetchAllWasCalled = true
        handler(.success(stories))
    }
}
