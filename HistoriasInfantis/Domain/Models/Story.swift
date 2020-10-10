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
    }
    
    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let paragraphs: [Paragraph]
    let createDate: Date
    let updateDate: Date
}
