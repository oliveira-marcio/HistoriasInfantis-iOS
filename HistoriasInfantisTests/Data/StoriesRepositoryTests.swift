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
        super.setUp()
        fakeStoriesGateway = FakeStoriesGateway()
        fakeStoriesLocalGateway = FakeStoriesLocalGateway()
        storiesRepository = StoriesRepositoryImplementation(
            storiesGateway: fakeStoriesGateway,
            storiesLocalGateway: fakeStoriesLocalGateway
        )
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

    func test_when_request_new_and_local_gateway_fails_to_clear_current_stories_then_should_return_persistence_save_error() {
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

        var error: StoriesRepositoryError?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.requestNew { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.unableToSave)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertFalse(fakeStoriesLocalGateway.insertWasCalled)
        XCTAssertEqual(fakeStoriesLocalGateway.stories, currentStories)
    }

    func test_when_request_new_and_local_gateway_fails_to_save_new_stories_then_should_return_persistence_save_error() {
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

        var error: StoriesRepositoryError?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.requestNew { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.unableToSave)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.insertWasCalled)
        XCTAssertEqual(fakeStoriesLocalGateway.stories, [Story]())
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

    func test_when_fetch_all_and_local_gateway_fails_then_request_new_is_called() {
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

        fakeStoriesLocalGateway.shouldFetchAllFail = true
        fakeStoriesGateway.stories = expectedStories

        var stories: [Story]?
        let requestExpectation = expectation(description: "request expectation")

        storiesRepository.fetchAll() { result in
            stories = try? result.dematerialize()
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchAllWasCalled)
        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.insertWasCalled)

        XCTAssertEqual(fakeStoriesLocalGateway.stories, expectedStories)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_when_fetch_all_and_there_is_no_local_stories_then_request_new_is_called() {
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

        fakeStoriesGateway.stories = expectedStories

        var stories: [Story]?
        let requestExpectation = expectation(description: "request expectation")

        storiesRepository.fetchAll() { result in
            stories = try? result.dematerialize()
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchAllWasCalled)
        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertTrue(fakeStoriesLocalGateway.insertWasCalled)

        XCTAssertEqual(fakeStoriesLocalGateway.stories, expectedStories)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_when_fetch_all_and_there_is_no_local_stories_and_web_gateway_fails_then_should_return_error() {
        fakeStoriesGateway.shouldRequestFail = true

        var error: StoriesRepositoryError?
        let requestExpectation = expectation(description: "request expectation")

        storiesRepository.fetchAll { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchAllWasCalled)
        XCTAssertTrue(fakeStoriesGateway.requestWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.gatewayRequestFail(fakeStoriesGateway.serverErrorMessage))
        XCTAssertFalse(fakeStoriesLocalGateway.clearAllWasCalled)
        XCTAssertFalse(fakeStoriesLocalGateway.insertWasCalled)
    }

    func test_when_fetch_favorites_then_local_gateway_fetch_favorites_is_called() {
        let expectedStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date(),
                favorite: true
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
            )
        ]

        fakeStoriesLocalGateway.stories = expectedStories

        var stories: [Story]?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.fetchFavorites { result in
            stories = try? result.dematerialize()
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchFavoritesWasCalled)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_when_fetch_favorites_and_there_is_no_favorites_then_should_return_empty_list() {
        var stories: [Story]?
        let fetchExpectation = expectation(description: "fetch expectation")

        storiesRepository.fetchFavorites { result in
            stories = try? result.dematerialize()
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchFavoritesWasCalled)
        XCTAssertEqual(stories, [])
    }

    func test_when_fetch_favorites_and_gateway_fails_then_should_return_error() {
        fakeStoriesLocalGateway.shouldFetchFavoritesFail = true

        var error: StoriesRepositoryError?
        let requestExpectation = expectation(description: "fetch expectation")

        storiesRepository.fetchFavorites { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesLocalGateway.fetchFavoritesWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.unableToRetrieve)
    }

    func test_given_unfavorited_story_when_toggle_favorite_then_local_gateway_update_is_called_with_true() {
        let unfavoritedStory = Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date(),
                favorite: false
            )

        let fetchExpectation = expectation(description: "toggle favorite expectation")

        storiesRepository.toggleFavorite(story: unfavoritedStory) { _ in
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(fakeStoriesLocalGateway.updateStoryId, 1)
        XCTAssertEqual(fakeStoriesLocalGateway.updateFavorite, true)
    }

    func test_given_favorited_story_when_toggle_favorite_then_local_gateway_update_is_called_with_false() {
        let favoritedStory = Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date(),
                favorite: true
            )

        let fetchExpectation = expectation(description: "toggle favorite expectation")

        storiesRepository.toggleFavorite(story: favoritedStory) { _ in
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(fakeStoriesLocalGateway.updateStoryId, 1)
        XCTAssertEqual(fakeStoriesLocalGateway.updateFavorite, false)
    }

    func test_given_favorited_story_when_toggle_favorite_and_local_gateway_fails_then_should_return_error() {
        let favoritedStory = Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: Date(),
                updateDate: Date(),
                favorite: true
            )

        fakeStoriesLocalGateway.shouldUpdateFail = true

        var error: StoriesRepositoryError?
        let fetchExpectation = expectation(description: "toggle favorite expectation")

        storiesRepository.toggleFavorite(story: favoritedStory) { resultError in
            error = resultError
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(fakeStoriesLocalGateway.updateStoryId, 1)
        XCTAssertEqual(fakeStoriesLocalGateway.updateFavorite, false)
        XCTAssertEqual(error, StoriesRepositoryError.unableToSave)
    }
}
