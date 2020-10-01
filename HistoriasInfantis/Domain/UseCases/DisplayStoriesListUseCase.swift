//
//  UseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias DisplayStoriesUseCaseCompletionHandler = (_ stories: Result<[Story]>) -> Void

protocol DisplayStoriesUseCase {
    func invoke(completion: @escaping DisplayStoriesUseCaseCompletionHandler)
}

class DisplayStoriesUseCaseImplementation: DisplayStoriesUseCase {
    private let storiesRepository: StoriesRepository!

    init(storiesRepository: StoriesRepository) {
        self.storiesRepository = storiesRepository
    }

    func invoke(completion: @escaping DisplayStoriesUseCaseCompletionHandler) {
        storiesRepository.fetchAll() { results in
            completion(results)
        }
    }
}
