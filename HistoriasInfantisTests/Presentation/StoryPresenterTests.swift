//
//  StoryPresenterTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

var presenter: StoryPresenter!
var viewSpy: StoryViewSpy!

let story = Story(
    id: 1,
    title: "Story 1",
    url: "http://story1",
    imageUrl: "http://image1",
    paragraphs: [.text("paragraph1")],
    createDate: Date(),
    updateDate: Date())


class StoryPresenterTests: XCTestCase {

    override func setUp() {
        super.setUp()

        viewSpy = StoryViewSpy()
        presenter = StoryPresenter(view: viewSpy, story: story)
    }

    func test_it_should_display_selected_story_when_view_did_load() {
        presenter.viewDidLoad()

        let loadExpectation = expectation(description: "load expectation")
        viewSpy.displayStoryHandler = {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewSpy.story, story)
    }
}
