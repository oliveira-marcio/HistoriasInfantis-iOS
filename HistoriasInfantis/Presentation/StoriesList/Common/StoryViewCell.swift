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
    @IBOutlet weak var storyLabel: UILabel!

    func display(image url: String, with imageLoader: ImageLoader, placeholder: String) {
        imageLoader.loadImage(from: url, into: storyImageView, placeholder: placeholder)
    }

    func display(title: String) {
        storyLabel.text = title
    }
}
