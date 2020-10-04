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
    var storiesGateway: StoriesGatewayImplementation!

    override func setUp() {
        urlSessionStub = URLSessionStub()
        storiesGateway = StoriesGatewayImplementation(urlSession: urlSessionStub, resultsPerPage: 50, maxPages: 10)
    }

    func test_should_fetch_stories_page_from_api_until_empty_response() {
        let response = """
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

        let emptyResponse = """
        {
            "posts": []
        }
        """

        let httpResponse = HTTPURLResponse(
            url: URL(string: "http://marcio.com")!,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: ["Content-Type": "application/json"]
        )

        urlSessionStub.enqueue(
            response: (
                data: response.data(using: .utf8),
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

        var stories: [Story]?
        let requestExpectation = expectation(description: "request completion expectation")

        storiesGateway.fetchStories { result in
            stories = try? result.dematerialize()
            requestExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        // TODO: Do proper assert
        XCTAssertEqual(stories?.first?.title ?? "", "Story 1")
        XCTAssertEqual(stories?.last?.title ?? "", "Story 2")
    }
}
