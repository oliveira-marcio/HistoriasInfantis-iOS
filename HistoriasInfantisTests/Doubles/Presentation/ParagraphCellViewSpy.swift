//
//  ParagraphCellViewSpy..swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

class ParagraphCellViewSpy: ParagraphCellView {
    var text: String?
    var author: String?
    var end: String?
    var image: Data?

    var displayImageHandler: (() -> Void)?

    func display(text: String) {
        self.text = text
    }

    func display(author: String) {
        self.author = author
    }

    func display(end: String) {
        self.end = end
    }

    func display(image: Data) {
        self.image = image
        displayImageHandler?()
    }
}
