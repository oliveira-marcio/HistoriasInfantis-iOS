//
//  ToggleFavoriteStoryUseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/15/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias ToggleFavoriteStoryUseCaseUseCaseCompletionHandler = (Result<Story>) -> Void

class ToggleFavoriteStoryUseCase {
    private let storiesRepository: StoriesRepository!

    init(storiesRepository: StoriesRepository) {
        self.storiesRepository = storiesRepository
    }

    func invoke(story: Story, then completion: @escaping ToggleFavoriteStoryUseCaseUseCaseCompletionHandler) {
        storiesRepository.toggleFavorite(story: story) { result in
            completion(result)
        }
    }
}
