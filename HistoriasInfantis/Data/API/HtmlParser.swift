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

        do {
            let doc: Document = try SwiftSoup.parse(html)
            if let paragraphs = try? doc.select("p") {
                var paragraphsArray = [Story.Paragraph]()
                for paragraph in paragraphs.array() {
                    if let text = try? paragraph.text() {
                        paragraphsArray.append(.text(text))
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
}
