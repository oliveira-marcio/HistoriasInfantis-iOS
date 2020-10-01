//
//  StoriesRepository.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//


typealias StoriesRepositoryFetchAllCompletionHandler = (_ stories: Result<[Story]>) -> Void

protocol StoriesRepository {
    func fetchAll(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler)
}

class StoriesRepositoryImplementation: StoriesRepository {
    private let storiesLocalGateway: StoriesLocalGateway!

    init(storiesLocalGateway: StoriesLocalGateway) {
        self.storiesLocalGateway = storiesLocalGateway
    }
    
    func fetchAll(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler) {
        storiesLocalGateway.fetchAll() { result in
            handler(result)
        }
    }
}
