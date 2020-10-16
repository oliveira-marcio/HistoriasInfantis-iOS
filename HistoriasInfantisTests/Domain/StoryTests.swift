//
//  StoryTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/16/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis

class StoryTests: XCTestCase {

    func test_it_should_return_correct_type_and_text_strings_when_is_text_paragraph() {
        let paragraph = Story.Paragraph.text("paragraph")

        XCTAssertEqual(paragraph.type, "text")
        XCTAssertEqual(paragraph.text, "paragraph")
    }

    func test_it_should_return_correct_type_and_text_strings_when_is_image_paragraph() {
        let paragraph = Story.Paragraph.image("paragraph")

        XCTAssertEqual(paragraph.type, "image")
        XCTAssertEqual(paragraph.text, "paragraph")
    }

    func test_it_should_return_correct_type_and_text_strings_when_is_author_paragraph() {
        let paragraph = Story.Paragraph.author("paragraph")

        XCTAssertEqual(paragraph.type, "author")
        XCTAssertEqual(paragraph.text, "paragraph")
    }

    func test_it_should_return_correct_type_and_text_strings_when_is_end_paragraph() {
        let paragraph = Story.Paragraph.end("paragraph")

        XCTAssertEqual(paragraph.type, "end")
        XCTAssertEqual(paragraph.text, "paragraph")
    }

    func test_it_should_make_text_paragraph_when_make_paragraph_is_called_with_valid_name_and_text() {
        let paragraph = Story.Paragraph.makeParagraph(with: "text", text: "paragraph")

        XCTAssertEqual(paragraph, Story.Paragraph.text("paragraph"))
    }

    func test_it_should_make_image_paragraph_when_make_paragraph_is_called_with_valid_name_and_text() {
        let paragraph = Story.Paragraph.makeParagraph(with: "image", text: "paragraph")

        XCTAssertEqual(paragraph, Story.Paragraph.image("paragraph"))
    }

    func test_it_should_make_author_paragraph_when_make_paragraph_is_called_with_valid_name_and_text() {
        let paragraph = Story.Paragraph.makeParagraph(with: "author", text: "paragraph")

        XCTAssertEqual(paragraph, Story.Paragraph.author("paragraph"))
    }

    func test_it_should_make_end_paragraph_when_make_paragraph_is_called_with_valid_name_and_text() {
        let paragraph = Story.Paragraph.makeParagraph(with: "end", text: "paragraph")

        XCTAssertEqual(paragraph, Story.Paragraph.end("paragraph"))
    }

    func test_it_should_make_text_paragraph_when_make_paragraph_is_called_with_valid_name_with_mixed_case_and_text() {
        let paragraph = Story.Paragraph.makeParagraph(with: "tExT", text: "paragraph")

        XCTAssertEqual(paragraph, Story.Paragraph.text("paragraph"))
    }

    func test_it_should_return_nil_when_make_paragraph_is_called_with_invalid_name_and_text() {
        let paragraph = Story.Paragraph.makeParagraph(with: "invalid", text: "paragraph")

        XCTAssertNil(paragraph)
    }
}
