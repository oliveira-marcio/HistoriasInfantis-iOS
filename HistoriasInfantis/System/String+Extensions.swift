//
//  String+Extensions.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/20/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

public extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

