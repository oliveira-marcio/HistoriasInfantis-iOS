//
//  DisplayFavoritesListUseCase.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class DisplayFavoritesListUseCase {
    private let storiesRepository: StoriesRepository!

    init(storiesRepository: StoriesRepository) {
        self.storiesRepository = storiesRepository
    }

    func invoke(completion: @escaping DisplayStoriesListUseCaseCompletionHandler) {
        storiesRepository.fetchFavorites { result in
            completion(result)
        }
    }
}
