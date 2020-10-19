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

    @IBOutlet weak var paragraphImageView: UIImageView!
    @IBOutlet weak var paragraphLabel: UILabel!

    func display(text: String) {
        paragraphLabel.text = text
        paragraphLabel.isHidden = false
        paragraphImageView.isHidden = true
    }

    func display(author: String) {
        paragraphLabel.text = author
        paragraphLabel.isHidden = false
        paragraphImageView.isHidden = true
    }

    func display(end: String) {
        paragraphLabel.text = end
        paragraphLabel.isHidden = false
        paragraphImageView.isHidden = true
    }

    func display(image url: String, with imageLoader: ImageLoader, placeholder: String) {
        paragraphLabel.isHidden = true
        paragraphImageView.isHidden = false
        imageLoader.loadImage(from: url, into: paragraphImageView, placeholder: placeholder)
    }
}
