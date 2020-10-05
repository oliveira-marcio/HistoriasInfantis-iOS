//
//  StoriesGatewayTest.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/4/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import XCTest
@testable import HistoriasInfantis

class StoriesGatewayTest: XCTestCase {
    var urlSessionStub: URLSessionStub!
    var fakeHtmlParser: FakeHtmlParser!
    var storiesGateway: StoriesGatewayImplementation!

    func test_should_fetch_stories_pages_from_api_until_empty_response_when_max_pages_is_big() {
        setRegularResponseTests()

        fakeHtmlParser = FakeHtmlParser()
        fakeHtmlParser.stories = [story1, story2, story3]

        storiesGateway = StoriesGatewayImplementation(
            urlSession: urlSessionStub,
            htmlParser: fakeHtmlParser,
            resultsPerPage: 2,
            maxPages: 10
        )

        var stories: [Story]?
        var storiesCount = 0
        let requestExpectation = expectation(description: "request completion expectation")

        storiesGateway.fetchStories { result in
            stories = try? result.dematerialize()
            storiesCount = stories?.count ?? 0
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(storiesCount, 3)
        XCTAssertEqual(fakeHtmlParser.parseWasCalled, 3)
        XCTAssertEqual(stories, [story1, story2, story3])
    }

    func test_should_fetch_stories_pages_from_api_until_max_pages() {
        setRegularResponseTests()

        fakeHtmlParser = FakeHtmlParser()
        fakeHtmlParser.stories = [story1, story2]

        storiesGateway = StoriesGatewayImplementation(
            urlSession: urlSessionStub,
            htmlParser: fakeHtmlParser,
            resultsPerPage: 2,
            maxPages: 1)

        var stories: [Story]?
        var storiesCount = 0
        let requestExpectation = expectation(description: "request completion expectation")

        storiesGateway.fetchStories { result in
            stories = try? result.dematerialize()
            storiesCount = stories?.count ?? 0
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(storiesCount, 2)
        XCTAssertEqual(fakeHtmlParser.parseWasCalled, 2)
        XCTAssertEqual(stories, [story1, story2])
    }

    func test_should_return_request_fail_when_gateway_fails() {
        urlSessionStub = URLSessionStub()

        fakeHtmlParser = FakeHtmlParser()
        fakeHtmlParser.stories = [story1, story2]

        storiesGateway = StoriesGatewayImplementation(
            urlSession: urlSessionStub,
            htmlParser: fakeHtmlParser,
            resultsPerPage: 2,
            maxPages: 10
        )

        urlSessionStub.enqueue(
            response: (
                data: firstPageResponse.data(using: .utf8),
                response: httpResponse,
                error: nil
            )
        )

        urlSessionStub.enqueue(
            response: (
                data: "".data(using: .utf8),
                response: HTTPURLResponse(statusCode: 500),
                error: nil
            )
        )

        var requestResult: Result<[Story]>?
        let requestExpectation = expectation(description: "request completion expectation")

        storiesGateway.fetchStories { result in
            requestResult = result
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertEqual(requestResult?.isSuccess, false)
        XCTAssertEqual(fakeHtmlParser.parseWasCalled, 2)
    }

    // MARK: Helpers

    private let httpResponse = HTTPURLResponse(
        url: URL(string: "http://marcio.com")!,
        statusCode: 200,
        httpVersion: "1.1",
        headerFields: ["Content-Type": "application/json"]
    )

    private let firstPageResponse = """
    {
        "posts": [
            {
                "ID": 1,
                "date": "2020-10-02T15:15:54-03:00",
                "modified": "2020-10-02T16:25:44-03:00",
                "title": "Story 1",
                "URL": "https://story1",
                "content": "<p>Just a paragraph in HTML</p>",
                "featured_image": "https://story1.jpg"
            },
            {
                "ID": 2,
                "date": "2020-10-03T15:15:54-03:00",
                "modified": "2020-10-03T16:25:44-03:00",
                "title": "Story 2",
                "URL": "https://story2",
                "content": "<p>Just another paragraph in HTML</p>",
                "featured_image": "https://story2.jpg"
            }
        ]
    }
    """

    private let secondPageResponse = """
    {
        "posts": [
            {
                "ID": 3,
                "date": "2020-10-04T15:15:54-03:00",
                "modified": "2020-10-04T16:25:44-03:00",
                "title": "Story 3",
                "URL": "https://story3",
                "content": "<p>One more paragraph in HTML</p>",
                "featured_image": "https://story3.jpg"
            }
        ]
    }
    """

    private let emptyResponse = """
    {
        "posts": []
    }
    """

    private let story1 = Story(
        id: 1,
        title: "Story 1",
        url: "https://story1",
        imageUrl: "https://story1.jpg",
        paragraphs: [],
        createDate: ISO8601DateFormatter().date(from: "2020-10-02T15:15:54-03:00")!,
        updateDate: ISO8601DateFormatter().date(from: "2020-10-02T16:25:44-03:00")!
    )

    private let story2 = Story(
        id: 2,
        title: "Story 2",
        url: "https://story2",
        imageUrl: "https://story2.jpg",
        paragraphs: [],
        createDate: ISO8601DateFormatter().date(from: "2020-10-03T15:15:54-03:00")!,
        updateDate: ISO8601DateFormatter().date(from: "2020-10-03T16:25:44-03:00")!
    )

    private let story3 = Story(
        id: 3,
        title: "Story 3",
        url: "https://story3",
        imageUrl: "https://story3.jpg",
        paragraphs: [],
        createDate: ISO8601DateFormatter().date(from: "2020-10-04T15:15:54-03:00")!,
        updateDate: ISO8601DateFormatter().date(from: "2020-10-04T16:25:44-03:00")!
    )

    private func setRegularResponseTests() {
        urlSessionStub = URLSessionStub()

        urlSessionStub.enqueue(
            response: (
                data: firstPageResponse.data(using: .utf8),
                response: httpResponse,
                error: nil
            )
        )
        urlSessionStub.enqueue(
            response: (
                data: secondPageResponse.data(using: .utf8),
                response: httpResponse,
                error: nil
            )
        )
        urlSessionStub.enqueue(
            response: (
                data: emptyResponse.data(using: .utf8),
                response: httpResponse,
                error: nil
            )
        )
    }
}
