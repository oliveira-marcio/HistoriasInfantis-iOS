//
//  ParagraphViewCell.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/10/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class ParagraphViewCell: UITableViewCell, ParagraphCellView {

    static var reuseIdentifier: String { "\(self)" }

    @IBOutlet weak var label: UILabel!

    func display(text: String) {
        label.text = text
    }

    func display(author: String) {
        label.text = author

    }

    func display(end: String) {
        label.text = end

    }

    func display(image: Data) {
        label.text = "IMAGE"
    }
}
