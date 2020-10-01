//
//  Result.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case failure(Error)

    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    public func dematerialize() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}
