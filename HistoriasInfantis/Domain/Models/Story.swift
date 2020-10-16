//
//  Story.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct Story: Equatable {
    enum Paragraph: Equatable {
        case text(String), image(String), author(String), end(String)

        var type: String {
            switch self {
            case .text(_): return "text"
            case .image(_): return "image"
            case .author(_): return "author"
            case .end(_): return "end"
            }
        }

        var text: String {
            switch self {
            case .text(let text): return text
            case .image(let text): return text
            case .author(let text): return text
            case .end(let text): return text
            }
        }

        static func makeParagraph(with name: String, text: String) -> Paragraph? {
            switch name.lowercased() {
            case "text": return .text(text)
            case "image": return .image(text)
            case "author": return .author(text)
            case "end": return .end(text)
            default: return nil
            }
        }
    }
    
    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let paragraphs: [Paragraph]
    let createDate: Date
    let updateDate: Date
    let favorite: Bool

    init(id: Int,
         title: String,
         url: String,
         imageUrl: String,
         paragraphs: [Paragraph],
         createDate: Date,
         updateDate: Date,
         favorite: Bool = false) {
        self.id = id
        self.title = title
        self.url = url
        self.imageUrl = imageUrl
        self.paragraphs = paragraphs
        self.createDate = createDate
        self.updateDate = updateDate
        self.favorite = favorite
    }
}
