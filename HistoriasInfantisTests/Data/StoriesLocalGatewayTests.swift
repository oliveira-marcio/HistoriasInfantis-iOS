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
        let expectedStories = populateSampleData()
        var fetchResult: [Story]?

        let fetchExpectation = expectation(description: "fetch all expectation")

        gateway.fetchAll { result in
            fetchResult = try? result.dematerialize()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(fetchResult, expectedStories)
    }

    func test_given_entries_stored_when_clear_all_then_should_return_empty_entries_on_fetch_all() {
        let _ = populateSampleData()
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

    func test_given_entries_stored_when_insert_stories_then_should_return_entries_on_fetch_all() {
        let initialStories = populateSampleData()
        let newStory = [
            Story(
                id: 6,
                title: "Story 6",
                url: "http://story6",
                imageUrl: "http://image6",
                paragraphs: [.text("paragraph6")],
                createDate: Date(),
                updateDate: Date())
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

    private func populateSampleData() -> [Story] {
        let stories = Array(1...5).map { id in
            Story(
                id: id,
                title: "Story \(id)",
                url: "http://story\(id)",
                imageUrl: "http://image\(id)",
                paragraphs: [.text("paragraph\(id)")],
                createDate: Date(),
                updateDate: Date())
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
