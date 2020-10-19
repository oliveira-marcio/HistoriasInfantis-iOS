//
//  AuthorParagraphViewCell.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/19/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class AuthorParagraphViewCell: UITableViewCell, AuthorParagraphCellView {
    @IBOutlet weak var paragraphAuthorLabel: UILabel!

    func display(author: String) {
        paragraphAuthorLabel.text = author
    }
}
