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
    }
    
    let title: String
    let url: String
    let imageUrl: String
    let paragraphs: [Paragraph]
    let createDate: Date
    let updateDate: Date
}
