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
            updateDate: Date()
        ),
        Story(
            id: 2,
            title: "Story 2",
            url: "http://story2",
            imageUrl: "http://image2",
            paragraphs: [.text("paragraph2")],
            createDate: Date(),
            updateDate: Date(),
            favorite: true
        ),
        Story(
            id: 2903,
            title: "Roy, o Cavalo que Queria ser Cowboy",
            url: "http://story3",
            imageUrl: "http://image3",
            paragraphs: [.text("paragraph3")],
            createDate: Date(),
            updateDate: Date(),
            favorite: true
        )
    ]

    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler) {
        handler(.success(stories))
    }

    func fetchFavorites(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler) {
        let favoriteStories = stories.filter { $0.favorite }
        handler(.success(favoriteStories))
    }

    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        stories = []
        handler(nil)

    }

    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        self.stories += stories
        handler(nil)
    }

    func update(storyId: Int, favorite: Bool, then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        self.stories = stories.map {
            $0.id != storyId ? $0 : Story(id: $0.id,
                                          title: $0.title,
                                          url: $0.url,
                                          imageUrl: $0.imageUrl,
                                          paragraphs: $0.paragraphs,
                                          createDate: $0.createDate,
                                          updateDate: $0.updateDate,
                                          favorite: favorite)
        }
        handler(nil)
    }
}
