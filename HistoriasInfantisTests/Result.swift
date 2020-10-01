//
//  Result.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    // Shouldn't be used for PRODUCTION enum comparison. Good enough for unit tests.
    return String(describing: lhs) == String(describing: rhs)
}
