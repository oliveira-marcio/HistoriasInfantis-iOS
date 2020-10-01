//
//  FakeStoriesRepository.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class FakeStoriesRepository: StoriesRepository {
    public var stories: [Story] = []

    func fetchAll(then handler: @escaping DisplayStoriesUseCaseCompletionHandler) {
        handler(.success(stories))
    }
}
