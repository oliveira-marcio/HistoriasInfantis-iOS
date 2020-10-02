//
//  RequestNewStoriesUseCaseTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class RequestNewStoriesUseCaseTests: XCTestCase {

    var fakeStoriesRepository: FakeStoriesRepository!
    var requestNewStoriesUseCase: RequestNewStoriesUseCase!

    override func setUp() {
        fakeStoriesRepository = FakeStoriesRepository()
        requestNewStoriesUseCase = RequestNewStoriesUseCaseImplementation(
            storiesRepository: fakeStoriesRepository
        )
    }

    func test_it_should_request_new_stories() {
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
        requestNewStoriesUseCase.invoke { [weak self] result in
            XCTAssertEqual(self?.fakeStoriesRepository.requestNewWasCalled, true)
            XCTAssertTrue(result == Result.success(expectedStories))
        }
    }
}
