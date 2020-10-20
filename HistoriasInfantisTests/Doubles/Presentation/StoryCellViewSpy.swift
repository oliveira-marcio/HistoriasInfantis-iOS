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
    var image: UIImage?
    var placeholder: String?

    func display(title: String) {
        self.title = title
    }

    func display(image: UIImage) {
        self.image = image

    }

    func display(image named: String) {
        self.placeholder = named
    }
}
