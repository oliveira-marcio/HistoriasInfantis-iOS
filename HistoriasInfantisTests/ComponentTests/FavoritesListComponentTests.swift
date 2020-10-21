//
//  FavoritesListComponentTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/21/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class FavoritesListComponentTests: XCTestCase {

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

    func test_it_should_display_favorites_list_when_view_did_load_and_there_are_stories_available() {

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

        doubles.storiesLocalGateway.favoriteStories = expectedStories

        doubles.favoritesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.favoritesListView.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.favoritesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.favoritesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.favoritesListView.didRequestRefreshStories)
        XCTAssertFalse(doubles.favoritesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.favoritesListView.storiesRetrievalError)
        XCTAssertEqual(doubles.favoritesListPresenter.stories.count, 2)
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

    func test_it_should_display_favorites_list_with_placeholder_images_when_view_did_load_and_there_are_stories_available_and_image_loader_fails() {

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

        doubles.storiesLocalGateway.favoriteStories = expectedStories
        doubles.imageLoader.shouldGetImageFail = true

        doubles.favoritesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.favoritesListView.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.favoritesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.favoritesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.favoritesListView.didRequestRefreshStories)
        XCTAssertFalse(doubles.favoritesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.favoritesListView.storiesRetrievalError)
        XCTAssertEqual(doubles.favoritesListPresenter.stories.count, 2)
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
        doubles.favoritesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.favoritesListView.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.favoritesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.favoritesListView.didRequestRefreshStories)
        XCTAssertTrue(doubles.favoritesListView.didRequestDisplayEmptyStories)
        XCTAssertNil(doubles.favoritesListView.storiesRetrievalError)
    }

    func test_it_should_display_empty_view_and_error_when_view_did_load_and_gateway_fails() {
        doubles.storiesLocalGateway.shouldFetchFavoritesFail = true

        doubles.favoritesListPresenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        doubles.favoritesListView.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.favoritesListView.didDisplayLoading, [true, false])
        XCTAssertFalse(doubles.favoritesListView.didRequestRefreshStories)
        XCTAssertTrue(doubles.favoritesListView.didRequestDisplayEmptyStories)
        XCTAssertEqual(doubles.favoritesListView.storiesRetrievalError, "persistence_error")
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
        doubles.favoritesListView.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        doubles.favoritesListPresenter.viewDidLoad()
        waitForExpectations(timeout: 1)

        doubles.storiesLocalGateway.favoriteStories = expectedStories
        doubles.favoritesListView.didDisplayLoading = []
        doubles.favoritesListView.didRequestRefreshStories = false

        let didUpdateFavoritesExpectation = expectation(description: "did update favorites expectation")
        doubles.favoritesListView.refreshStoriesHandler = {
            didUpdateFavoritesExpectation.fulfill()
        }

        doubles.eventNotifier.notify(notification: StoriesRepositoryNotification.didUpdateFavorites)
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            doubles.favoritesListPresenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.favoritesListView.didDisplayLoading, [true, false])
        XCTAssertTrue(doubles.favoritesListView.didRequestRefreshStories)
        XCTAssertEqual(doubles.favoritesListPresenter.stories.count, 2)
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
        doubles.favoritesListPresenter.stories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date,
                favorite: true)
        ]

        doubles.favoritesListPresenter.showStory(at: 0)

        XCTAssertEqual(doubles.baseStoriesListViewRouter.story, doubles.favoritesListPresenter.stories[0])
    }
}
