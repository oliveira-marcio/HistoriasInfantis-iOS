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
    var fakeStoriesRepository: FakeStoriesRepository!

    override func setUp() {
        super.setUp()

        viewSpy = StoriesListViewSpy()
        fakeStoriesRepository = FakeStoriesRepository()
        presenter = StoriesListPresenter(view: viewSpy,
                                         storiesRepository: fakeStoriesRepository)
    }

    func test_it_should_display_stories_list_when_view_did_load_and_there_are_stories_available() {

    }

    func test_it_should_display_empty_view_and_display_error_when_view_did_load_and_there_are_no_stories_available() {

    }

    func test_it_should_display_refreshed_stories_when_refresh_is_called_and_there_are_stories_available() {

    }

    func test_it_should_display_error_when_refresh_is_called_and_repository_fails_to_retrieve_new_stories() {

    }
}
