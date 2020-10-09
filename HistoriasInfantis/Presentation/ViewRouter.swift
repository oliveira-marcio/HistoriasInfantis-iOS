//
//  ViewRouter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

public protocol ViewRouter {
    func prepare(for segue: Any, sender: Any?)
}

public extension ViewRouter {
    func prepare(for segue: Any, sender: Any?) {}
}
