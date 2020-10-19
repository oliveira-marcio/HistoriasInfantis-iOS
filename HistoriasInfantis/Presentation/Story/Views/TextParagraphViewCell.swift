//
//  TextParagraphViewCell.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/19/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class TextParagraphViewCell: UITableViewCell, TextParagraphCellView {
    @IBOutlet weak var paragraphTextLabel: UILabel!

    func display(text: String) {
        paragraphTextLabel.text = text
    }
}
