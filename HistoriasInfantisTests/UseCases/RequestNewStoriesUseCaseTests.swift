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
        super.setUp()
        fakeStoriesRepository = FakeStoriesRepository()
        requestNewStoriesUseCase = RequestNewStoriesUseCaseImplementation(
            storiesRepository: fakeStoriesRepository
        )
    }

    func test_it_should_request_new_stories() {
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

        requestNewStoriesUseCase.invoke { result in
            stories = try? result.dematerialize()
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.requestNewWasCalled)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_it_should_return_gateway_error_when_request_new_stories_fails_because_of_web_gateway() {
        fakeStoriesRepository.shouldGatewayFail = true

        var error: StoriesRepositoryError?
        let useCaseExpectation = expectation(description: "use case expectation")

        requestNewStoriesUseCase.invoke { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.requestNewWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.gatewayRequestFail(fakeStoriesRepository.serverErrorMessage))
    }

    func test_it_should_return_save_error_when_request_new_stories_fails_because_of_local_gateway() {
        fakeStoriesRepository.shouldLocalGatewayFail = true

        var error: StoriesRepositoryError?
        let useCaseExpectation = expectation(description: "use case expectation")

        requestNewStoriesUseCase.invoke { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.requestNewWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.unableToSave)
    }
}
