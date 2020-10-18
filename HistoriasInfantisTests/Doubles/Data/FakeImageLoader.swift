//
//  FakeImageLoader.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

class FakeImageLoader: ImageLoader {
    var data: Data?
    var urls = [String]()
    var shouldFail = false

    func getImage(from url: String, completion: @escaping (Data?) -> Void) {
        urls.append(url)
        completion(shouldFail ? nil : data)
    }
}
