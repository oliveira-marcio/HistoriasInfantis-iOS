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

    func loadImage(from url: String, into view: UIImageView, placeholder: String) {
        urls.append(url)
        view.image = UIImage()
        loadImageCompletion?()
    }
}
