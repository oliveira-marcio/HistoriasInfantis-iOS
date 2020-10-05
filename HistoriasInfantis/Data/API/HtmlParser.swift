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
    func parse(
        html: String,
        id: Int,
        title: String,
        url: String,
        imageUrl: String,
        createDate: Date,
        updateDate: Date) -> Story {

        let tokenBR = "#!#br2n#!#"
        let tagP = "p"
        let tagIMG = "img"
        let tagSRC = "src"
        let tagFIGURE = "figure"

        do {
            var preparedHtml = replaceAll(from: html, regEx: "(?i)<br[^>]*>", with: tokenBR)
            preparedHtml = replaceAll(from: preparedHtml, regEx: "<((\\\\/)?)\(tagFIGURE)", with: "<$1\(tagP)")

            let doc: Document = try SwiftSoup.parse(preparedHtml)
            if let paragraphs = try? doc.select(tagP) {
                var paragraphsArray = [Story.Paragraph]()

                for paragraph in paragraphs.array() {
                    if let text = try? paragraph.text(), !text.isEmpty {
                        let paragraphString = text.replacingOccurrences(of: tokenBR, with: "\n")

                        paragraphsArray.append(.text(paragraphString))
                    }

                    if let images = try? doc.select(tagIMG) {
                        for image in images.array() {
                            if let url = try? image.absUrl(tagSRC) {
                                var imageUrl: String
                                if let urlEnd = url.firstIndex(of: "?") {
                                    imageUrl = String(url[..<urlEnd])
                                } else {
                                    imageUrl = url
                                }

                                paragraphsArray.append(.image(imageUrl))
                            }
                        }
                    }
                }

                return Story(
                    id: id,
                    title: title,
                    url: url,
                    imageUrl: imageUrl,
                    paragraphs: paragraphsArray,
                    createDate: createDate,
                    updateDate: updateDate
                )
            }
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

    private func replaceAll(from text: String, regEx: String, with substr: String) -> String {
        let regex = try? NSRegularExpression(pattern: regEx, options: .caseInsensitive)
        return regex?.stringByReplacingMatches(in: text, options: [], range: NSRange(0..<text.utf16.count), withTemplate: substr) ?? text
    }
}
