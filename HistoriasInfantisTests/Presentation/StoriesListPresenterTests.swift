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
    var routerSpy: StoriesListViewRouterSpy!
    var fakeStoriesRepository: FakeStoriesRepository!

    let date = Date()

    override func setUp() {
        super.setUp()

        viewSpy = StoriesListViewSpy()
        routerSpy = StoriesListViewRouterSpy()
        fakeStoriesRepository = FakeStoriesRepository()
        presenter = StoriesListPresenter(view: viewSpy,
                                         router: routerSpy,
                                         displayStoriesListUseCase: DisplayStoriesListUseCase(storiesRepository: fakeStoriesRepository),
                                         requestNewStoriesUseCase: RequestNewStoriesUseCase(storiesRepository: fakeStoriesRepository))
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
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[1].title, "Story 2")
    }

    func test_it_should_display_empty_view_and_display_error_when_view_did_load_and_there_are_no_stories_available() {
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
        XCTAssertEqual(cellSpies[0].title, "Story 1")
        XCTAssertEqual(cellSpies[1].title, "Story 2")
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
