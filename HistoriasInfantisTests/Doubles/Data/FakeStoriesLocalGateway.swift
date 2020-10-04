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
    var clearAllWasCalled = false
    var insertWasCalled = false

    var shouldClearAllFail = false
    var shouldInsertFail = false

    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler) {
        fetchAllWasCalled = true
        handler(.success(stories))
    }

    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        clearAllWasCalled = true
        if !shouldClearAllFail {
            stories = []
        }
        handler(shouldClearAllFail ? nil : StoriesRepositoryError.unableToSave)

    }

    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        insertWasCalled = true
        if !shouldInsertFail {
            self.stories = stories
        }
        handler(shouldInsertFail ? nil : StoriesRepositoryError.unableToSave)
    }
}