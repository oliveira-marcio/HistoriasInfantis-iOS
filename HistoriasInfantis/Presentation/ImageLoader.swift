//
//  ImageLoader.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol ImageLoader {
    func getImage(from url: String, completion: @escaping (Data?) -> Void)
}
