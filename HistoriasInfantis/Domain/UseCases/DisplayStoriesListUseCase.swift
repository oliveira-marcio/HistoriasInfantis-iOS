//
//  DisplayStoriesListUseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias DisplayStoriesListUseCaseCompletionHandler = (Result<[Story]>) -> Void

class DisplayStoriesListUseCase {
    private let storiesRepository: StoriesRepository!

    init(storiesRepository: StoriesRepository) {
        self.storiesRepository = storiesRepository
    }

    func invoke(completion: @escaping DisplayStoriesListUseCaseCompletionHandler) {
        storiesRepository.fetchAll { result in
            completion(result)
        }
    }
}
