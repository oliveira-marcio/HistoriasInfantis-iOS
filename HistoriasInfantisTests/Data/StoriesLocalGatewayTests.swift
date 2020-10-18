//
//  StoriesLocalGatewayTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class StoriesLocalGatewayTests: XCTestCase {

    var gateway: CoreDataStoriesLocalGateway!

    override func setUp() {
        super.setUp()
        gateway = CoreDataStoriesLocalGateway()
        clearStoredData()
    }

    override func tearDown() {
        gateway = CoreDataStoriesLocalGateway()
        clearStoredData()
    }

    func test_given_no_entries_stored_when_fetch_all_entries_then_return_empty() {
        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "fetch all expectation")

        gateway.fetchAll { result in
            fetchResult = try? result.dematerialize()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, [])
    }

    func test_given_entries_stored_when_fetch_all_entries_then_should_return_all_entries() {
        let expectedStories = populateSampleData(values: 5)
        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "fetch all expectation")

        gateway.fetchAll { result in
            fetchResult = try? result.dematerialize()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, expectedStories)
    }

    func test_given_no_entries_stored_when_fetch_favorites_entries_then_return_empty() {
        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "fetch favorites expectation")

        gateway.fetchFavorites { result in
            fetchResult = try? result.dematerialize()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, [])
    }

    func test_given_entries_stored_when_fetch_favorites_entries_then_should_return_favorite_entries() {
        let stories = populateSampleData(values: 5, favoriteIds: [1, 4])
        let expectedStories = [stories[1], stories[4]]

        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "fetch favorites expectation")

        gateway.fetchFavorites { result in
            fetchResult = try? result.dematerialize()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, expectedStories)
    }

    func test_given_entries_stored_when_clear_all_then_should_return_empty_entries_on_fetch_all() {
        let _ = populateSampleData(values: 5)
        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "clear all expectation")

        gateway.clearAll { [weak self] _ in
            self?.gateway.fetchAll { result in
                fetchResult = try? result.dematerialize()
                fetchExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, [])
    }

    func test_given_entries_stored_when_insert_stories_then_should_return_updated_entries_on_fetch_all() {
        let initialStories = populateSampleData(values: 5)
        let date = Date()
        let newStory = [
            Story(
                id: 6,
                title: "Story 6",
                url: "http://story6",
                imageUrl: "http://image6",
                paragraphs: [.text("paragraph6")],
                createDate: date,
                updateDate: date)
        ]


        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "insert stories expectation")

        gateway.insert(stories: newStory) { [weak self] _ in
            self?.gateway.fetchAll { result in
                fetchResult = try? result.dematerialize()
                fetchExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, initialStories + newStory)
    }

    func test_given_entries_stored_when_update_story_then_should_return_updated_entries_on_fetch_all() {
        _ = populateSampleData(values: 5)

        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "update story expectation")

        gateway.update(storyId: 2, favorite: true) { [weak self] _ in
            self?.gateway.fetchAll { result in
                fetchResult = try? result.dematerialize()
                fetchExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult?[0].id, 5)
        XCTAssertEqual(fetchResult?[0].favorite, false)

        XCTAssertEqual(fetchResult?[1].id, 4)
        XCTAssertEqual(fetchResult?[1].favorite, false)

        XCTAssertEqual(fetchResult?[2].id, 3)
        XCTAssertEqual(fetchResult?[2].favorite, false)

        XCTAssertEqual(fetchResult?[3].id, 2)
        XCTAssertEqual(fetchResult?[3].favorite, true)

        XCTAssertEqual(fetchResult?[4].id, 1)
        XCTAssertEqual(fetchResult?[4].favorite, false)
    }

    private func populateSampleData(values: Int, favoriteIds: [Int] = []) -> [Story] {
        let stories = Array(1...values).reversed().map { id in
            Story(
                id: id,
                title: "Story \(id)",
                url: "http://story\(id)",
                imageUrl: "http://image\(id)",
                paragraphs: [.text("paragraph\(id)")],
                createDate: Calendar.current.date(byAdding: .day, value: id, to: Date())!,
                updateDate: Date(),
                favorite: favoriteIds.contains(id)
            )
        }

        let insertExpectation = expectation(description: "Insert records expectation")

        gateway.insert(stories: stories) { error in
            if let _ = error {
                XCTFail("Failed to insert records.")
            }

            insertExpectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        return stories
    }

    private func clearStoredData() {
        let clearAllExpectation = expectation(description: "Clear all expectation")

        gateway.clearAll { error in
            if let _ = error {
                XCTFail("Failed to clear records.")
            }

            clearAllExpectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
