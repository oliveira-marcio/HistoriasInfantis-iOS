//
//  StoriesEntity.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/4/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

struct StoriesEntity: Codable {
    let stories: [StoryEntity]
    let meta: MetaEntity
    var hasMoreStories: Bool {
        meta.next_page != nil
    }

    enum CodingKeys: String, CodingKey {
        case stories = "posts"
        case meta
    }
}

struct MetaEntity: Codable {
    let next_page: String?
}

struct StoryEntity: Codable {
    let title: String
}

