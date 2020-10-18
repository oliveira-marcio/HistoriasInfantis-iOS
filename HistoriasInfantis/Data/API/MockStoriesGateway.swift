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
        return Array(1...last).reversed().map { id in
            let todayDate = Date()
            return Story(
                id: id,
                title: "Story \(id)",
                url: "http://story\(id)",
                imageUrl: "http://image\(id)",
                paragraphs: [
                    .text("paragraph\(id)-1"),
                    .image("http://image\(id)"),
                    .text("paragraph\(id)-2"),
                    .end("FIM"),
                    .author("Rodrigo Lopes")
                ],
                createDate: Calendar.current.date(byAdding: .day, value: id, to: todayDate)!,
                updateDate: Calendar.current.date(byAdding: .day, value: id, to: todayDate)!,
                favorite: false
            )
        }
    }
}
