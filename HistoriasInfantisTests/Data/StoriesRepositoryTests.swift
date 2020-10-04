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

    var fakeStoriesGateway: FakeStoriesGateway!
    var fakeStoriesLocalGateway: FakeStoriesLocalGateway!
    var storiesRepository: StoriesRepositoryImplementation!

    override func setUp() {
        fakeStoriesGateway = FakeStoriesGateway()
        fakeStoriesLocalGateway = FakeStoriesLocalGateway()
        storiesRepository = StoriesRepositoryImplementation(
            storiesGateway: fakeStoriesGateway,
            storiesLocalGateway: fakeStoriesLocalGateway
        )
    }

    func test_when_fetch_all_then_local_gateway_fetch_all_is_called() {
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

        fakeStoriesLocalGateway.stories = expectedStories

        var stories: [Story]?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.fetchAll { result in
            stories = try? result.dematerialize()
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchAllWasCalled)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_when_request_new_then_stories_are_synced_between_web_and_local_gateway() {
        let currentStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date())
        ]

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

        fakeStoriesLocalGateway.stories = currentStories
        fakeStoriesGateway.stories = expectedStories

        var stories: [Story]?
        let requestExpectation = expectation(description: "request expectation")

        storiesRepository.requestNew() { result in
            stories = try? result.dematerialize()
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.insertWasCalled)

        XCTAssertEqual(fakeStoriesLocalGateway.stories, expectedStories)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_when_request_new_and_web_gateway_fails_then_should_return_error_and_should_not_update_local_gateway() {
        fakeStoriesGateway.shouldRequestFail = true

        var error: StoriesRepositoryError?
        let requestExpectation = expectation(description: "request expectation")

        storiesRepository.requestNew { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.gatewayRequestFail(fakeStoriesGateway.serverErrorMessage))
        XCTAssertFalse(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertFalse(fakeStoriesLocalGateway.insertWasCalled)
    }

    func test_when_request_new_and_local_gateway_fails_to_clear_current_stories_then_should_just_return_fetched_stories() {
        let currentStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date())
        ]

        let fetchedStories = [
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

        fakeStoriesGateway.stories = fetchedStories
        fakeStoriesLocalGateway.stories = currentStories
        fakeStoriesLocalGateway.shouldClearAllFail = true

        var stories: [Story]?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.requestNew { result in
            stories = try? result.dematerialize()
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertEqual(stories, fetchedStories)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertFalse(fakeStoriesLocalGateway.insertWasCalled)
        XCTAssertEqual(fakeStoriesLocalGateway.stories, currentStories)
    }

    func test_when_request_new_and_local_gateway_fails_to_save_new_stories_then_should_just_return_fetched_stories() {
        let currentStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date())
        ]

        let fetchedStories = [
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

        fakeStoriesGateway.stories = fetchedStories
        fakeStoriesLocalGateway.stories = currentStories
        fakeStoriesLocalGateway.shouldInsertFail = true

        var stories: [Story]?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.requestNew { result in
            stories = try? result.dematerialize()
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertEqual(stories, fetchedStories)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.insertWasCalled)
        XCTAssertEqual(fakeStoriesLocalGateway.stories, [Story]())
    }
}
