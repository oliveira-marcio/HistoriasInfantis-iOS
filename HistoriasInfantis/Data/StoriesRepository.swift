//
//  StoriesRepository.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

protocol StoriesRepository {
    func fetchAll(then handler: @escaping DisplayStoriesUseCaseCompletionHandler)
}
