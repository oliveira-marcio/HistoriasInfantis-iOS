//
//  StoriesRepository.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias StoriesRepositoryFetchCompletionHandler = (Result<[Story]>) -> Void
typealias StoriesRepositoryWriteErrorCompletionHandler = (StoriesRepositoryError?) -> Void

public enum StoriesRepositoryError: Error, Equatable {
    case gatewayRequestFail(String)
    case gatewayParseFail(String)
    case unableToRetrieve
    case unableToSave
}

public enum StoriesRepositoryNotification: String, NotificationRepresentable {
    case didUpdateFavorites
}

protocol StoriesRepository {
    func fetchAll(then handler: @escaping StoriesRepositoryFetchCompletionHandler)
    func requestNew(then handler: @escaping StoriesRepositoryFetchCompletionHandler)
    func fetchFavorites(then handler: @escaping StoriesRepositoryFetchCompletionHandler)
    func toggleFavorite(story: Story, then handler: @escaping StoriesRepositoryWriteErrorCompletionHandler)
}
