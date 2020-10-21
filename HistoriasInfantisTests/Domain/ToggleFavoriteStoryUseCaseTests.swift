//
//  ToggleFavoriteStoryUseCaseTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/15/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class ToggleFavoriteStoryUseCaseTests: XCTestCase {

    var fakeStoriesRepository: FakeStoriesRepository!
    var toggleFavoriteStoryUseCase: ToggleFavoriteStoryUseCase!
    var date: Date!
    var story: Story!

    override func setUp() {
        super.setUp()

        date = Date()
        story = Story(
            id: 1,
            title: "Story 1",
            url: "http://story1",
            imageUrl: "http://image1",
            paragraphs: [
                .text("Paragraph 1"),
                .image("http://image2"),
                .text("Paragraph 2"),
                .end("The End"),
                .author("Author")
            ],
            createDate: date,
            updateDate: date)

        fakeStoriesRepository = FakeStoriesRepository()
        toggleFavoriteStoryUseCase = ToggleFavoriteStoryUseCase(
            storiesRepository: fakeStoriesRepository
        )
    }

    func test_it_should_toggle_favorite_state() {
        let favoritedStory = Story(
            id: 1,
            title: "Story 1",
            url: "http://story1",
            imageUrl: "http://image1",
            paragraphs: [.text("paragraph1")],
            createDate: date,
            updateDate: date,
            favorite: true
        )

        var favoriteToggledStory: Story?
        let useCaseExpectation = expectation(description: "use case expectation")

        fakeStoriesRepository.favoriteToggledStory = favoritedStory

        toggleFavoriteStoryUseCase.invoke(story: story) { result in
            favoriteToggledStory = try? result.dematerialize()
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.toggleFavoriteWasCalled)
        XCTAssertEqual(favoriteToggledStory, favoritedStory)
    }

    func test_it_should_return_gateway_error_when_toggle_favorite_fails() {
        fakeStoriesRepository.shouldToggleFavoriteFail = true

        var error: StoriesRepositoryError?
        let useCaseExpectation = expectation(description: "use case expectation")

        toggleFavoriteStoryUseCase.invoke(story: story) { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.toggleFavoriteWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.unableToSave)
    }

}
