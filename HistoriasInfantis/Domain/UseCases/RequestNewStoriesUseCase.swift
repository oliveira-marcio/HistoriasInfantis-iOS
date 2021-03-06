//
//  RequestNewStoriesUseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias RequestNewStoriesUseCaseCompletionHandler = (Result<[Story]>) -> Void

class RequestNewStoriesUseCase {
    private let storiesRepository: StoriesRepository!

    init(storiesRepository: StoriesRepository) {
        self.storiesRepository = storiesRepository
    }

    func invoke(completion: @escaping RequestNewStoriesUseCaseCompletionHandler) {
        storiesRepository.requestNew { result in
            completion(result)
        }
    }
}

