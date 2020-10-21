//
//  StoryComponentTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/21/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class StoryComponentTests: XCTestCase {

    private var doubles: ComponentTestDoubles!

    private var presenter: StoryPresenter!
    private var viewSpy: StoryViewSpy!
    private var fakeImageLoader: FakeImageLoader!
    private var fakeStoriesRepository: FakeStoriesRepository!

    private var date: Date!
    private var unfavoriteStory: Story!
    private var favoriteStory: Story!

    override func setUp() {
        super.setUp()

        doubles = ComponentTestDoubles()

        date = Date()

        unfavoriteStory = Story(
            id: 1,
            title: "Story 1",
            url: "http://story1",
            imageUrl: "http://storyimage",
            paragraphs: [
                .text("Paragraph 1"),
                .image("http://image1"),
                .text("Paragraph 2"),
                .end("The End"),
                .author("Author")
            ],
            createDate: date,
            updateDate: date,
            favorite: false)

        favoriteStory = Story(
            id: 1,
            title: "Story 1",
            url: "http://story1",
            imageUrl: "http://storyimage",
            paragraphs: [
                .text("Paragraph 1"),
                .image("http://image1"),
                .text("Paragraph 2"),
                .end("The End"),
                .author("Author")
            ],
            createDate: date,
            updateDate: date,
            favorite: true)


        presenter = StoryPresenter(view: doubles.storyView,
                                   story: unfavoriteStory,
                                   imageLoader: doubles.imageLoader,
                                   toggleFavoriteStoryUseCase: doubles.toggleFavoriteStoryUseCase)
    }

    func test_it_should_display_story_title_and_image_when_view_did_load() {
        presenter.viewDidLoad()

        XCTAssertEqual(doubles.storyView.title, unfavoriteStory.title)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://storyimage"])
        XCTAssertEqual(doubles.storyView.image, UIImage())
    }

    func test_it_should_display_only_story_title_when_view_did_load_and_image_loader_fails() {
        doubles.imageLoader.shouldGetImageFail = true
        presenter.viewDidLoad()

        XCTAssertEqual(doubles.storyView.title, unfavoriteStory.title)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://storyimage"])
        XCTAssertNil(doubles.storyView.image)
    }


    func test_it_should_return_paragraph_type_from_selected_paragraph_when_get_paragraph_type_is_called() {
        for i in (0..<unfavoriteStory.paragraphs.count) {
            XCTAssertEqual(
                presenter.getParagraphType(for: i),
                unfavoriteStory.paragraphs[i].type
            )
        }
    }

    func test_it_should_display_complete_story_when_view_did_load() {
        let cellSpies = unfavoriteStory.paragraphs.map { _ in ParagraphCellViewSpy() }
        for index in 0..<cellSpies.count {
            presenter.configureCell(cellSpies[index], for: index)
        }

        XCTAssertEqual(doubles.imageLoader.urls, ["http://image1"])

        XCTAssertEqual(cellSpies[0].text, "Paragraph 1")
        XCTAssertNil(cellSpies[0].author)
        XCTAssertNil(cellSpies[0].end)
        XCTAssertNil(cellSpies[0].image)

        XCTAssertNil(cellSpies[1].text)
        XCTAssertNil(cellSpies[1].author)
        XCTAssertNil(cellSpies[1].end)
        XCTAssertEqual(cellSpies[1].imageLoading, [true, false])
        XCTAssertEqual(cellSpies[1].image, UIImage())

        XCTAssertEqual(cellSpies[2].text, "Paragraph 2")
        XCTAssertNil(cellSpies[2].author)
        XCTAssertNil(cellSpies[2].end)
        XCTAssertNil(cellSpies[2].image)

        XCTAssertNil(cellSpies[3].text)
        XCTAssertNil(cellSpies[3].author)
        XCTAssertEqual(cellSpies[3].end, "The End")
        XCTAssertNil(cellSpies[3].image)

        XCTAssertNil(cellSpies[4].text)
        XCTAssertEqual(cellSpies[4].author, "Author")
        XCTAssertNil(cellSpies[4].end)
        XCTAssertNil(cellSpies[4].image)
    }

    func test_it_should_display_complete_story_without_images_when_view_did_load_and_image_loader_fails() {
        doubles.imageLoader.shouldGetImageFail = true

        let cellSpies = unfavoriteStory.paragraphs.map { _ in ParagraphCellViewSpy() }
        for index in 0..<cellSpies.count {
            presenter.configureCell(cellSpies[index], for: index)
        }

        XCTAssertEqual(cellSpies[0].text, "Paragraph 1")
        XCTAssertNil(cellSpies[0].author)
        XCTAssertNil(cellSpies[0].end)
        XCTAssertNil(cellSpies[0].image)

        XCTAssertNil(cellSpies[1].text)
        XCTAssertNil(cellSpies[1].author)
        XCTAssertNil(cellSpies[1].end)
        XCTAssertEqual(cellSpies[1].imageLoading, [true, false])
        XCTAssertNil(cellSpies[1].image)
        XCTAssertEqual(doubles.imageLoader.urls, ["http://image1"])

        XCTAssertEqual(cellSpies[2].text, "Paragraph 2")
        XCTAssertNil(cellSpies[2].author)
        XCTAssertNil(cellSpies[2].end)
        XCTAssertNil(cellSpies[2].image)

        XCTAssertNil(cellSpies[3].text)
        XCTAssertNil(cellSpies[3].author)
        XCTAssertEqual(cellSpies[3].end, "The End")
        XCTAssertNil(cellSpies[3].image)

        XCTAssertNil(cellSpies[4].text)
        XCTAssertEqual(cellSpies[4].author, "Author")
        XCTAssertNil(cellSpies[4].end)
        XCTAssertNil(cellSpies[4].image)
    }

    func test_it_should_display_favorite_button_marked_when_view_did_load_when_story_is_favorite() {
        presenter = StoryPresenter(view: doubles.storyView,
                                   story: favoriteStory,
                                   imageLoader: doubles.imageLoader,
                                   toggleFavoriteStoryUseCase: doubles.toggleFavoriteStoryUseCase)

        presenter.viewDidLoad()

        XCTAssertEqual(doubles.storyView.favorited, true)
    }

    func test_it_should_display_favorite_button_unmarked_when_view_did_load_when_story_is_not_favorite() {
        presenter.viewDidLoad()

        XCTAssertEqual(doubles.storyView.favorited, false)
    }

    func test_it_should_add_movie_to_favorites_and_toggle_button_state_when_toggle_favorite_is_called_and_story_is_not_favorite() {
        let toggleExpectation = expectation(description: "toggle favorite expectation")

        doubles.storyView.displayFavoritedHandler = {
            toggleExpectation.fulfill()
        }

        presenter.toggleFavorite()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(presenter.story, favoriteStory)
        XCTAssertEqual(doubles.storyView.favorited, true)
    }

    func test_it_should_remove_movie_from_favorites_and_toggle_button_state_when_toggle_favorite_is_called_and_story_is_favorite() {
        presenter = StoryPresenter(view: doubles.storyView,
                                   story: favoriteStory,
                                   imageLoader: doubles.imageLoader,
                                   toggleFavoriteStoryUseCase: doubles.toggleFavoriteStoryUseCase)

        let toggleExpectation = expectation(description: "toggle favorite expectation")

        doubles.storyView.displayFavoritedHandler = {
            toggleExpectation.fulfill()
        }

        presenter.toggleFavorite()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(presenter.story, unfavoriteStory)
        XCTAssertEqual(doubles.storyView.favorited, false)
    }

    func test_it_should_display_error_and_keep_button_state_when_toggle_favorite_fails() {
        let toggleExpectation = expectation(description: "toggle favorite expectation")

        doubles.storyView.displayFavoritedHandler = {
            toggleExpectation.fulfill()
        }

        doubles.storiesLocalGateway.shouldUpdateFail = true
        presenter.toggleFavorite()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(doubles.storyView.error, "toggle_favorite_error")
        XCTAssertNil(doubles.storyView.favorited)
    }
}
