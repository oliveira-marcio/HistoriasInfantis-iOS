//
//  DisplayStoriesListUseCaseTests.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class DisplayStoriesListUseCaseTests: XCTestCase {

    var fakeStoriesRepository: FakeStoriesRepository!
    var displayStoriesListUseCase: DisplayStoriesListUseCase!

    override func setUp() {
        super.setUp()
        fakeStoriesRepository = FakeStoriesRepository()
        displayStoriesListUseCase = DisplayStoriesListUseCase(
            storiesRepository: fakeStoriesRepository
        )
    }

    func test_it_should_display_stories_list() {
        let expectedStories = [
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

        fakeStoriesRepository.stories = expectedStories

        var stories: [Story]?
        let useCaseExpectation = expectation(description: "use case expectation")

        displayStoriesListUseCase.invoke { result in
            stories = try? result.dematerialize()
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.fetchAllWasCalled)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_it_should_display_gateway_error_when_fetch_all_fails() {
        fakeStoriesRepository.shouldFetchAllFail = true

        var error: StoriesRepositoryError?
        let useCaseExpectation = expectation(description: "use case expectation")

        displayStoriesListUseCase.invoke { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.fetchAllWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.gatewayRequestFail(fakeStoriesRepository.serverErrorMessage))
    }
}
