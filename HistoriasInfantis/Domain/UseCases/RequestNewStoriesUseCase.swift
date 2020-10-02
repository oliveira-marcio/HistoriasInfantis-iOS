//
//  RequestNewStoriesUseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias RequestNewStoriesUseCaseCompletionHandler = (_ stories: Result<[Story]>) -> Void

protocol RequestNewStoriesUseCase {
    func invoke(completion: @escaping RequestNewStoriesUseCaseCompletionHandler)
}

class RequestNewStoriesUseCaseImplementation: RequestNewStoriesUseCase {
    private let storiesRepository: StoriesRepository!

    init(storiesRepository: StoriesRepository) {
        self.storiesRepository = storiesRepository
    }

    func invoke(completion: @escaping RequestNewStoriesUseCaseCompletionHandler) {
        storiesRepository.requestNew() { result in
            completion(result)
        }
    }
}

