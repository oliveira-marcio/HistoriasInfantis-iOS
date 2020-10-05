//
//  HtmlParserTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/5/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class HtmlParserTests: XCTestCase {

    var htmlParser: SwiftSoupHtmlParser!
    var expectedStory: Story!

    override func setUp() {
        htmlParser = SwiftSoupHtmlParser()
    }

    func test_it_should_parse_text_paragraphs_from_P_tags() {
        let html = """
            <html>
                <p>First <b>Paragraph</b>.</p>
                <p>Second Paragraph.</p>
                <p>Third Paragraph.</p>
            </html>
        """

        let paragraphs: [Story.Paragraph] = [
            .text("First Paragraph."),
            .text("Second Paragraph."),
            .text("Third Paragraph.")
        ]

        expectedStory = createStory(with: paragraphs)

        let story = htmlParser.parse(
            html: html,
            id: expectedStory.id,
            title: expectedStory.title,
            url: expectedStory.url,
            imageUrl: expectedStory.imageUrl,
            createDate: expectedStory.createDate,
            updateDate: expectedStory.updateDate
        )

        XCTAssertEqual(story, expectedStory)
    }

    func test_it_should_return_empty_paragraphs_when_format_is_invalid() {
        let html = """
            No <br>
        good<!>
                format
        """

        expectedStory = createStory(with: [])

        let story = htmlParser.parse(
            html: html,
            id: expectedStory.id,
            title: expectedStory.title,
            url: expectedStory.url,
            imageUrl: expectedStory.imageUrl,
            createDate: expectedStory.createDate,
            updateDate: expectedStory.updateDate
        )

        XCTAssertEqual(story, expectedStory)
    }

    private func createStory(with paragraphs: [Story.Paragraph]) -> Story {
        return Story(
            id: 1,
            title: "Story 1",
            url: "https://story1",
            imageUrl: "https://story1.jpg",
            paragraphs: paragraphs,
            createDate: ISO8601DateFormatter().date(from: "2020-10-02T15:15:54-03:00")!,
            updateDate: ISO8601DateFormatter().date(from: "2020-10-02T16:25:44-03:00")!
        )
    }
}
