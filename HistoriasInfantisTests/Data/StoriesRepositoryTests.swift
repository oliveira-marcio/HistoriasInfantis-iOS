//
//  StoriesRepositoryTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class StoriesRepositoryTests: XCTestCase {

    var fakeStoriesLocalGateway: FakeStoriesLocalGateway!
    var storiesRepository: StoriesRepositoryImplementation!

    override func setUp() {
        fakeStoriesLocalGateway = FakeStoriesLocalGateway()
        storiesRepository = StoriesRepositoryImplementation(storiesLocalGateway: fakeStoriesLocalGateway)
    }

    func test_when_fetch_all_then_gateway_fetch_all_is_called() {
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

        fakeStoriesLocalGateway.stories = expectedStories
        storiesRepository.fetchAll() { [weak self] result in
            XCTAssertEqual(self?.fakeStoriesLocalGateway.fetchAllWasCalled, true)
            XCTAssertTrue(result == Result.success(expectedStories))
        }
    }
}
