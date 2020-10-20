//
//  StoryViewCell.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StoryViewCell: UITableViewCell, StoryCellView {

    static var reuseIdentifier: String { "\(self)" }

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var storyLabel: UILabel!

    func display(title: String) {
        storyLabel.text = title
    }

    func display(image: UIImage) {
        storyImageView.image = image
    }

    func display(image named: String) {
        storyImageView.image = UIImage(named: named)
    }

    func display(imageLoading: Bool) {
        imageLoading ? storyImageActivityIndicator.startAnimating() : storyImageActivityIndicator.stopAnimating()
    }
}
