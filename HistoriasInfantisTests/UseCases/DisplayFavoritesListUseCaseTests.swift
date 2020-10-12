//
//  DisplayFavoritesListUseCaseTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class DisplayFavoritesListUseCaseTests: XCTestCase {

    var fakeStoriesRepository: FakeStoriesRepository!
    var displayFavoritesListUseCase: DisplayFavoritesListUseCase!

    override func setUp() {
        super.setUp()
        fakeStoriesRepository = FakeStoriesRepository()
        displayFavoritesListUseCase = DisplayFavoritesListUseCase(
            storiesRepository: fakeStoriesRepository
        )
    }

    func test_it_should_display_stories_list() {
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

        fakeStoriesRepository.stories = expectedStories

        var stories: [Story]?
        let useCaseExpectation = expectation(description: "use case expectation")

        displayFavoritesListUseCase.invoke { result in
            stories = try? result.dematerialize()
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.fetchFavoritesWasCalled)
        XCTAssertEqual(stories, expectedStories)
    }

    func test_it_should_display_gateway_error_when_fetch_all_fails() {
        fakeStoriesRepository.shouldFetchFavoritesFail = true

        var error: StoriesRepositoryError?
        let useCaseExpectation = expectation(description: "use case expectation")

        displayFavoritesListUseCase.invoke { result in
            if case .failure(let resultError) = result {
                error = resultError as? StoriesRepositoryError
            }
            useCaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(fakeStoriesRepository.fetchFavoritesWasCalled)
        XCTAssertEqual(error, StoriesRepositoryError.unableToRetrieve)
    }
}
