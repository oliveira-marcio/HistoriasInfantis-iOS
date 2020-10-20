//
//  StoriesListPresenterTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class StoriesListPresenterTests: XCTestCase {

    var presenter: StoriesListPresenter!
    var viewSpy: StoriesListViewSpy!
    var fakeImageLoader: FakeImageLoader!
    var routerSpy: StoriesListViewRouterSpy!
    var fakeStoriesRepository: FakeStoriesRepository!
    var eventNotifierStub: EventNotifierStub!

    let date = Date()

    override func setUp() {
        super.setUp()

        viewSpy = StoriesListViewSpy()
        fakeImageLoader = FakeImageLoader()
        routerSpy = StoriesListViewRouterSpy()
        fakeStoriesRepository = FakeStoriesRepository()
        eventNotifierStub = EventNotifierStub()
        presenter = StoriesListPresenter(view: viewSpy,
                                         imageLoader: fakeImageLoader,
                                         router: routerSpy,
                                         displayStoriesListUseCase: DisplayStoriesListUseCase(storiesRepository: fakeStoriesRepository),
                                         requestNewStoriesUseCase: RequestNewStoriesUseCase(storiesRepository: fakeStoriesRepository),
                                         eventNotifier: eventNotifierStub)
    }

    override func tearDown() {
        eventNotifierStub.tearDown()
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

        fakeStoriesRepository.stories = expectedStories

        presenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            presenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertTrue(viewSpy.didRequestRefreshStories)
        XCTAssertFalse(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertNil(viewSpy.storiesRetrievalError)
        XCTAssertEqual(presenter.stories.count, 2)
        XCTAssertEqual(fakeImageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].image, UIImage())
        XCTAssertNil(cellSpies[0].placeholder)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
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

        fakeStoriesRepository.stories = expectedStories
        fakeImageLoader.shouldGetImageFail = true

        presenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            presenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertTrue(viewSpy.didRequestRefreshStories)
        XCTAssertFalse(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertNil(viewSpy.storiesRetrievalError)
        XCTAssertEqual(presenter.stories.count, 2)
        XCTAssertEqual(fakeImageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].placeholder, "placeholder")
        XCTAssertNil(cellSpies[0].image)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].placeholder, "placeholder")
        XCTAssertNil(cellSpies[1].image)
    }

    func test_it_should_display_empty_view_when_view_did_load_and_there_are_no_stories_available() {
        presenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertFalse(viewSpy.didRequestRefreshStories)
        XCTAssertTrue(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertNil(viewSpy.storiesRetrievalError)
    }

    func test_it_should_display_empty_view_and_error_when_view_did_load_and_there_are_no_stories_available() {
        fakeStoriesRepository.shouldFetchAllFail = true

        presenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertFalse(viewSpy.didRequestRefreshStories)
        XCTAssertTrue(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertEqual(viewSpy.storiesRetrievalError, "Server Error")
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

        fakeStoriesRepository.stories = expectedStories

        presenter.refresh()

        let loadExpectation = expectation(description: "refresh expectation")
        viewSpy.refreshStoriesHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            presenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertTrue(viewSpy.didRequestRefreshStories)
        XCTAssertFalse(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertNil(viewSpy.storiesRetrievalError)
        XCTAssertEqual(presenter.stories.count, 2)
        XCTAssertEqual(fakeImageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].image, UIImage())
        XCTAssertNil(cellSpies[0].placeholder)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].image, UIImage())
        XCTAssertNil(cellSpies[1].placeholder)
    }

    func test_it_should_display_empty_stories_when_refresh_is_called_and_there_are_no_stories_available() {
        presenter.refresh()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertFalse(viewSpy.didRequestRefreshStories)
        XCTAssertTrue(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertNil(viewSpy.storiesRetrievalError)
    }

    func test_it_should_display_server_error_when_refresh_is_called_and_web_gateway_fails() {
        fakeStoriesRepository.shouldGatewayFail = true

        presenter.refresh()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertFalse(viewSpy.didRequestRefreshStories)
        XCTAssertFalse(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertEqual(viewSpy.storiesRetrievalError, "Server Error")
    }

    func test_it_should_display_empty_stories_and_persistence_error_when_refresh_is_called_and_sync_with_local_gateway_fails() {
        fakeStoriesRepository.shouldLocalGatewayFail = true

        presenter.refresh()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.displayStoriesRetrievalErrorHandler = {
            loadExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertFalse(viewSpy.didRequestRefreshStories)
        XCTAssertTrue(viewSpy.didRequestDisplayEmptyStories)
        XCTAssertEqual(viewSpy.storiesRetrievalError, "Persistence Error")
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
        viewSpy.displayEmptyStoriesHandler = {
            loadExpectation.fulfill()
        }

        presenter.viewDidLoad()
        waitForExpectations(timeout: 1)

        fakeStoriesRepository.stories = expectedStories
        viewSpy.didDisplayLoading = []
        viewSpy.didRequestRefreshStories = false

        let didUpdateFavoritesExpectation = expectation(description: "did update favorites expectation")
        viewSpy.refreshStoriesHandler = {
            didUpdateFavoritesExpectation.fulfill()
        }

        eventNotifierStub.notify(notification: StoriesRepositoryNotification.didUpdateFavorites)
        waitForExpectations(timeout: 1)

        let cellSpies = expectedStories.map { _ in StoryCellViewSpy() }
        for index in 0..<cellSpies.count {
            presenter.configureStoryCellView(cellSpies[index], for: index)
        }

        XCTAssertEqual(viewSpy.didDisplayLoading, [true, false])
        XCTAssertTrue(viewSpy.didRequestRefreshStories)
        XCTAssertEqual(presenter.stories.count, 2)
        XCTAssertEqual(fakeImageLoader.urls, ["http://image1", "http://image2"])
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[0].image, UIImage())
        XCTAssertNil(cellSpies[0].placeholder)
        XCTAssertEqual(cellSpies[1].title, "Story 2")
        XCTAssertEqual(cellSpies[1].image, UIImage())
        XCTAssertNil(cellSpies[1].placeholder)
    }

    func test_it_should_navigate_to_selected_story_when_show_story_is_called() {
        presenter.stories = [
            Story(
                id: 1,
                title: "Story 1",
                url: "http://story1",
                imageUrl: "http://image1",
                paragraphs: [.text("paragraph1")],
                createDate: date,
                updateDate: date)
        ]

        presenter.showStory(at: 0)

        XCTAssertEqual(routerSpy.story, presenter.stories[0])
    }
}
