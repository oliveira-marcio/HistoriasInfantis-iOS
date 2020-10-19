//
//  StoryCellViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import UIKit
@testable import HistoriasInfantis

class StoryCellViewSpy: StoryCellView {
    var title: String?
    var image: Data?
    var imageView = UIImageView()

    func display(image url: String, with imageLoader: ImageLoader, placeholder: String) {
        imageLoader.loadImage(from: url, into: imageView, placeholder: placeholder)
    }

    func display(title: String) {
        self.title = title
    }
}
