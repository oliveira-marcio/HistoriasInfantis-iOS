//
//  StoriesListComponentTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/20/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class StoriesListComponentTests: XCTestCase {

    private var doubles: ComponentTestDoubles!
    private var date: Date!

    override func setUp() {
        super.setUp()

        date = Date()
        doubles = ComponentTestDoubles()
    }

    override func tearDown() {
        doubles.eventNotifier.tearDown()
    }

    func test_it_should_display_stories_list_when_view_did_load_and_there_are_stories_available() {
        let expectedStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date),
            Story(
                id: 2,
                title: "Story 2",
                url: "http://story2",
                imageUrl: "http://image2",
                paragraphs: [.text("paragraph2")],
                createDate: date,
                updateDate: date)
        ]

        doubles.storiesGateway.stories = expectedStories

        doubles.storiesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.storiesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertFalse(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.storiesListView.storiesRetrievalError)
        XCTAssertEqual(doubles.storiesListPresenter.stories.count, 2)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[0].image, UIImage())
        XCTAssertNil(cellSpies[0].placeholder)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[1].image, UIImage())
        XCTAssertNil(cellSpies[1].placeholder)
    }

    func test_it_should_display_stories_list_with_placeholder_images_when_view_did_load_and_there_are_stories_available_and_image_loader_fails() {
        let expectedStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date),
            Story(
                id: 2,
                title: "Story 2",
                url: "http://story2",
                imageUrl: "http://image2",
                paragraphs: [.text("paragraph2")],
                createDate: date,
                updateDate: date)
        ]

        doubles.storiesGateway.stories = expectedStories
        doubles.imageLoader.shouldGetImageFail = true

        doubles.storiesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.storiesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertFalse(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.storiesListView.storiesRetrievalError)
        XCTAssertEqual(doubles.storiesListPresenter.stories.count, 2)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].placeholder, "placeholder")
        XCTAssertEqual(cellSpies[0].imageLoading, [true, false])
        XCTAssertNil(cellSpies[0].image)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].placeholder, "placeholder")
        XCTAssertNil(cellSpies[1].image)
        XCTAssertEqual(cellSpies[1].imageLoading, [true, false])
    }

    func test_it_should_display_empty_view_when_view_did_load_and_there_are_no_stories_available() {
        doubles.storiesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertTrue(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.storiesListView.storiesRetrievalError)
    }

    func test_it_should_display_empty_view_and_error_when_view_did_load_and_there_are_no_stories_available() {
        doubles.storiesGateway.shouldRequestFail = true

        doubles.storiesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertTrue(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertEqual(doubles.storiesListView.storiesRetrievalError, "server_error")
    }

    func test_it_should_display_refreshed_stories_when_refresh_is_called_and_there_are_stories_available() {
        let expectedStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date),
            Story(
                id: 2,
                title: "Story 2",
                url: "http://story2",
                imageUrl: "http://image2",
                paragraphs: [.text("paragraph2")],
                createDate: date,
                updateDate: date)
        ]

        doubles.storiesGateway.stories = expectedStories

        doubles.storiesListPresenter.refresh()

        let loadExpectation = expectation(description: "refresh expectation")
        doubles.storiesListView.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.storiesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertFalse(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.storiesListView.storiesRetrievalError)
        XCTAssertEqual(doubles.storiesListPresenter.stories.count, 2)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[0].image, UIImage())
        XCTAssertNil(cellSpies[0].placeholder)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[1].image, UIImage())
        XCTAssertNil(cellSpies[1].placeholder)
    }

    func test_it_should_display_empty_stories_when_refresh_is_called_and_there_are_no_stories_available() {
        doubles.storiesListPresenter.refresh()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertTrue(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.storiesListView.storiesRetrievalError)
    }

    func test_it_should_display_server_error_when_refresh_is_called_and_web_gateway_fails() {
        doubles.storiesGateway.shouldRequestFail = true

        doubles.storiesListPresenter.refresh()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertFalse(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertEqual(doubles.storiesListView.storiesRetrievalError, "server_error")
    }

    func test_it_should_display_empty_stories_and_persistence_error_when_refresh_is_called_and_sync_with_local_gateway_fails() {
        doubles.storiesLocalGateway.shouldInsertFail = true

        doubles.storiesListPresenter.refresh()

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertTrue(doubles.storiesListView.didRequestDisplayEmptyStories)
        XCTAssertEqual(doubles.storiesListView.storiesRetrievalError, "persistence_error")
    }

    func test_it_should_refresh_stories_list_when_repository_notifies_persistence_update() {
        let expectedStories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date,
                favorite: true),
            Story(
                id: 2,
                title: "Story 2",
                url: "http://story2",
                imageUrl: "http://image2",
                paragraphs: [.text("paragraph2")],
                createDate: date,
                updateDate: date,
                favorite: true)
        ]

        let loadExpectation = expectation(description: "load expectation")
        doubles.storiesListView.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        doubles.storiesListPresenter.viewDidLoad()
        waitForExpectations(timeout: 1)

        doubles.storiesLocalGateway.stories = expectedStories
        doubles.storiesListView.didDisplayLoading = []
        doubles.storiesListView.didRequestRefreshStories = false

        let didUpdateFavoritesExpectation = expectation(description: "did update favorites expectation")
        doubles.storiesListView.refreshStoriesHandler = {
            didUpdateFavoritesExpectation.fulfill()
        }

        doubles.eventNotifier.notify(notification: StoriesRepositoryNotification.didUpdateFavorites)
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.storiesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.storiesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.storiesListView.didRequestRefreshStories)
        XCTAssertEqual(doubles.storiesListPresenter.stories.count, 2)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[0].image, UIImage())
        XCTAssertNil(cellSpies[0].placeholder)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[1].image, UIImage())
        XCTAssertNil(cellSpies[1].placeholder)
    }

    func test_it_should_navigate_to_selected_story_when_show_story_is_called() {
        doubles.storiesListPresenter.stories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date)
        ]

        doubles.storiesListPresenter.showStory(at: 0)

        XCTAssertEqual(doubles.baseStoriesListViewRouter.story, doubles.storiesListPresenter.stories[0])
    }
}

