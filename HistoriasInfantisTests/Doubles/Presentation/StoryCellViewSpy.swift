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

    func display(image url: String, with imageLoader: ImageLoader, placeholder: String) {
        imageLoader.loadImage(from: url, into: UIImageView(), placeholder: placeholder)
    }

    func display(title: String) {
        self.title = title
    }
}
