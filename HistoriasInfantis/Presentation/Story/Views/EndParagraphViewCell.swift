//
//  EndParagraphViewCell.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/19/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class EndParagraphViewCell: UITableViewCell, EndParagraphCellView {
    @IBOutlet weak var paragraphEndLabel: UILabel!

    func display(end: String) {
        paragraphEndLabel.text = end
    }
}
