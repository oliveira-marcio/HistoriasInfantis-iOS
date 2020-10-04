//
//  StoriesEntity.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/4/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

struct StoriesEntity: Codable {
    let stories: [StoryEntity]

    enum CodingKeys: String, CodingKey {
        case stories = "posts"
    }
}

struct StoryEntity: Codable {
    let title: String
}
