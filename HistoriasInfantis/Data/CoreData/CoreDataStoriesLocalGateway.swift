//
//  MemoryStoriesLocalGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

/// TODO: Initially an in-memory database. It should be replaced by real CoreData stack
class CoreDataStoriesLocalGateway: StoriesLocalGateway {
    var stories = [
        Story(
            id: 1,
            title: "Story 1",
            url: "http://story1",
            imageUrl: "http://image1",
            paragraphs: [.text("paragraph1")],
            createDate: Date(),
            updateDate: Date()),
        Story(
            id: 2,
            title: "Story 2",
            url: "http://story2",
            imageUrl: "http://image2",
            paragraphs: [.text("paragraph2")],
            createDate: Date(),
            updateDate: Date())
    ]

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
