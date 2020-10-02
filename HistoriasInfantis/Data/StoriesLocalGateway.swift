//
//  StoriesLocalGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias StoriesLocalGatewayFetchAllCompletionHandler = (Result<[Story]>) -> Void
typealias StoriesLocalGatewayWriteErrorCompletionHandler = (StoriesRepositoryError?) -> Void

protocol StoriesLocalGateway {
    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler)
    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler)
    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler)
}
