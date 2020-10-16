//
//  StoriesGatewayImplementation.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class MockStoriesGateway: StoriesGateway {

    func fetchStories(then handler: @escaping StoriesGatewayRequestCompletionHandler) {
        let stories = populateSampleData(last: 5)
        handler(.success(stories))
    }

    private func populateSampleData(last: Int) -> [Story] {
        return Array(1...last).map { id in
            Story(
                id: id,
                title: "Story \(id)",
                url: "http://story\(id)",
                imageUrl: "http://image\(id)",
                paragraphs: [.text("paragraph\(id)")],
                createDate: Date(),
                updateDate: Date(),
                favorite: false
            )
        }
    }
}
