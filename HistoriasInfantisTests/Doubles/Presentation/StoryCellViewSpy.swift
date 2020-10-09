//
//  StoryCellViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

class StoryCellViewSpy: StoryCellView {
    var imageData: Data?
    var imageName: String?
    var title: String?

    func display(image from: Data) {
        imageData = from
    }

    func display(image named: String) {
        imageName = named
    }

    func display(title: String) {
        self.title = title
    }
}
