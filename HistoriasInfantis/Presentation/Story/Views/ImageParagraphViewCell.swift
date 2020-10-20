//
//  ImageParagraphViewCell.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/19/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class ImageParagraphViewCell: UITableViewCell, ImageParagraphCellView {
    @IBOutlet weak var paragraphImageView: UIImageView!

    func display(image: UIImage) {
        paragraphImageView.image = image
    }
}
