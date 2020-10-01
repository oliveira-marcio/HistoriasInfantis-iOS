//
//  DisplayStoriesUseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class DisplayStoriesUseCaseTests: XCTestCase {

    var fakeStoriesRepository: FakeStoriesRepository!

    var displayStoriesUseCase: DisplayStoriesUseCase!

    override func setUp() {
        fakeStoriesRepository = FakeStoriesRepository()
        displayStoriesUseCase = DisplayStoriesUseCaseImplementation(
            storiesRepository: fakeStoriesRepository
        )
    }

    func test_it_should_display_stories_list() {
        let expectedStories = [
            Story(
                name: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date()),
            Story(
                name: "Story 2",
                url: "http://story2",
                imageUrl: "http://image2",
                paragraphs: [.text("paragraph2")],
                createDate: Date(),
                updateDate: Date())
        ]

        fakeStoriesRepository.stories = expectedStories
        displayStoriesUseCase.invoke { result in
            XCTAssertTrue(result == Result.success(expectedStories))
        }
    }
}
