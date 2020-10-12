//
//  HtmlParser.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/5/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import SwiftSoup

protocol HtmlParser {
    func parse(html: String,
               id: Int,
               title: String,
               url: String,
               imageUrl: String,
               createDate: Date,
               updateDate: Date) -> Story
}

class SwiftSoupHtmlParser: HtmlParser {
    let author: String!
    let end: String!

    private let tokenBR = "#!#br2n#!#"
    private let tagP = "p"
    private let tagIMG = "img"
    private let tagSRC = "src"
    private let tagFIGURE = "figure"

    init(author: String, end: String) {
        self.author = author
        self.end = end
    }

    func parse(
        html: String,
        id: Int,
        title: String,
        url: String,
        imageUrl: String,
        createDate: Date,
        updateDate: Date) -> Story {

        do {
            /// Replace <BR> tags with temporary token
            var preparedHtml = replaceAll(from: html, regEx: "(?i)<br[^>]*>", with: tokenBR)

            /// Replace <FIGURE> tags by <P> tags.
            preparedHtml = replaceAll(from: preparedHtml, regEx: "<((\\\\/)?)\(tagFIGURE)", with: "<$1\(tagP)")

            let doc: Document = try SwiftSoup.parse(preparedHtml)
            var paragraphsArray = [Story.Paragraph]()

            /// Parse content from <P> tags only
            if let paragraphs = try? doc.select(tagP) {
                paragraphsArray += parseParagraphs(paragraphs: paragraphs.array())
            }

            return Story(
                id: id,
                title: unescapeHtml(from: title),
                url: url,
                imageUrl: imageUrl,
                paragraphs: paragraphsArray,
                createDate: createDate,
                updateDate: updateDate
            )
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("Unknown error in HTML parser")
        }

        return Story(
            id: id,
            title: title,
            url: url,
            imageUrl: imageUrl,
            paragraphs: [],
            createDate: createDate,
            updateDate: updateDate
        )
    }

    private func unescapeHtml(from htmlEncodedString: String) -> String {
        return (try? Entities.unescape(htmlEncodedString)) ?? htmlEncodedString
    }

    private func replaceAll(from text: String, regEx: String, with substr: String) -> String {
        let regex = try? NSRegularExpression(pattern: regEx, options: .caseInsensitive)
        return regex?.stringByReplacingMatches(in: text, options: [], range: NSRange(0..<text.utf16.count), withTemplate: substr) ?? text
    }

    private func parseParagraphs(paragraphs: [Element]) -> [Story.Paragraph] {
        var paragraphsArray = [Story.Paragraph]()

        /// Try to extract author, end and regular paragraphs. Author should be the last one, so it should ignore paragraphs after.
        paragraphLoop: for paragraph in paragraphs {
            if let text = try? paragraph.text(), !text.isEmpty {
                var paragraphString = text.trimmingCharacters(in: .whitespacesAndNewlines)

                /// Replace temporary tokens by break lines
                paragraphString = replaceAll(from: paragraphString, regEx: "\(tokenBR)\\s*", with: "\n")

                switch paragraphString.lowercased() {
                case author.lowercased():
                    paragraphsArray.append(.author(paragraphString))
                    break paragraphLoop
                case end.lowercased():
                    paragraphsArray.append(.end(paragraphString))
                default:
                    paragraphsArray.append(.text(paragraphString))
                }
            }

            /// Try to extract images URLs from <IMG> tags inside <P> or <FIGURE> tags
            if let images = try? paragraph.select(tagIMG) {
                paragraphsArray += parseImagesFromParagraph(images: images.array())
            }
        }

        return paragraphsArray
    }

    private func parseImagesFromParagraph(images: [Element]) -> [Story.Paragraph] {
        var paragraphsArray = [Story.Paragraph]()

        for image in images {
            if let url = try? image.absUrl(tagSRC) {
                var imageUrl: String

                /// Ignore extra query parameters in image URL
                if let urlEnd = url.firstIndex(of: "?") {
                    imageUrl = String(url[..<urlEnd])
                } else {
                    imageUrl = url
                }

                paragraphsArray.append(.image(imageUrl))
            }
        }

        return paragraphsArray
    }
}
