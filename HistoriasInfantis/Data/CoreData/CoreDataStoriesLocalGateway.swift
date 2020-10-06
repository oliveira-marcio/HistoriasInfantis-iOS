//
//  MemoryStoriesLocalGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

/// TODO: Initially an in-memory database. It should be replaced by real CoreData stack
class CoreDataStoriesLocalGateway: StoriesLocalGateway {
    var stories = [Story]()

    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler) {
        handler(.success(stories))
    }

    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        stories = []
        handler(nil)

    }

    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        self.stories += stories
        handler(nil)
    }
}
