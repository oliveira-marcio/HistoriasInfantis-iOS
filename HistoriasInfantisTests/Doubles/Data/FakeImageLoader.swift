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
    var data: Data?
    var urls = [String]()
    var shouldFail = false
    var loadImageCompletion: (() -> Void)?

    func loadImage(from url: String, into view: UIImageView, placeholder: String) {
        urls.append(url)
        loadImageCompletion?()
    }
}
