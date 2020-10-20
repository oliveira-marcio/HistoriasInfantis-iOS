//
//  FakeImageLoader.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import UIKit
@testable import HistoriasInfantis

class FakeImageLoader: ImageLoader {
    var urls = [String]()
    var loadImageCompletion: (() -> Void)?
    var shouldGetImageFail = false

    func getImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        urls.append(url)
        completion(shouldGetImageFail ? nil : UIImage())
        loadImageCompletion?()
    }
}
