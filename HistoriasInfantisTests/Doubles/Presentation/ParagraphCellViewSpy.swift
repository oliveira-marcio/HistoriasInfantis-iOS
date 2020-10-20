//
//  ParagraphCellViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
@testable import HistoriasInfantis

class ParagraphCellViewSpy: TextParagraphCellView, ImageParagraphCellView, EndParagraphCellView, AuthorParagraphCellView {
    static var reuseIdentifier: String = "ParagraphCellViewSpy"

    var image: UIImage?
    var text: String?
    var end: String?
    var author: String?

    func display(text: String) {
        self.text = text
    }

    func display(image: UIImage) {
        self.image = image
    }

    func display(end: String) {
        self.end = end
    }

    func display(author: String) {
        self.author = author
    }
}
