//
//  StoriesEntity.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/4/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct StoriesEntity: Codable {
    let stories: [StoryEntity]

    enum CodingKeys: String, CodingKey {
        case stories = "posts"
    }
}

struct StoryEntity: Codable {
    let ID: Int
    let date: Date
    let modified: Date
    let title: String
    let URL: String
    let content: String
    let featuredImage: String
}
