//
//  StoriesLocalGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias StoriesLocalGatewayFetchCompletionHandler = (Result<[Story]>) -> Void
typealias StoriesLocalGatewayWriteErrorCompletionHandler = (StoriesRepositoryError?) -> Void

protocol StoriesLocalGateway {
    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler)
    func fetchFavorites(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler)
    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler)
    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler)
    func update(storyId: Int, favorite: Bool, then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler)
}
