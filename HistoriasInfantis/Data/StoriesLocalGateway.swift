//
//  StoriesLocalGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

typealias StoriesLocalGatewayFetchAllCompletionHandler = (_ stories: Result<[Story]>) -> Void

protocol StoriesLocalGateway {
    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchAllCompletionHandler)
}
