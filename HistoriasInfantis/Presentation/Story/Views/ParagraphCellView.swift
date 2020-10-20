//
//  ParagraphCellView.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/10/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

protocol ParagraphCellView: class {
    static var reuseIdentifier: String { get }
}

extension ParagraphCellView where Self: UIView {
    static var reuseIdentifier: String { return "\(self)" }
}

protocol TextParagraphCellView: ParagraphCellView {
    func display(text: String)
}

protocol ImageParagraphCellView: ParagraphCellView {
    func display(image from: UIImage)
}

protocol EndParagraphCellView: ParagraphCellView {
    func display(end: String)
}

protocol AuthorParagraphCellView: ParagraphCellView {
    func display(author: String)
}
