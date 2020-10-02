//
//  StoriesGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

typealias StoriesGatewayRequestCompletionHandler = (Result<[Story]>) -> Void

protocol StoriesGateway {
    func request(then handler: @escaping StoriesGatewayRequestCompletionHandler)
}
