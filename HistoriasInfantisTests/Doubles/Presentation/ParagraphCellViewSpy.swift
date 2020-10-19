//
//  ParagraphCellViewSpy..swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import UIKit
@testable import HistoriasInfantis

class ParagraphCellViewSpy: ParagraphCellView {

    var text: String?
    var author: String?
    var end: String?

    func display(text: String) {
        self.text = text
    }

    func display(author: String) {
        self.author = author
    }

    func display(end: String) {
        self.end = end
    }

    func display(image url: String, with imageLoader: ImageLoader, placeholder: String) {
        imageLoader.loadImage(from: url, into: UIImageView(), placeholder: placeholder)
    }
}
