//
//  StoriesRepository.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias StoriesRepositoryFetchAllCompletionHandler = (Result<[Story]>) -> Void

public enum StoriesRepositoryError: Error, Equatable {
    case gatewayRequestFail(String)
    case gatewayParseFail(String)
    case unableToRetrieve
    case unableToSave
}

protocol StoriesRepository {
    func fetchAll(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler)
    func requestNew(then handler: @escaping StoriesRepositoryFetchAllCompletionHandler)
}
