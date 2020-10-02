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

    func fetchAll(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        fetchAllWasCalled = true
        handler(.success(stories))
    }

    func requestNew(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        requestNewWasCalled = true
        handler(.success(stories))
    }
}
