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

    @IBOutlet weak var label: UILabel!

    func display(image from: Data) {

    }

    func display(image named: String) {

    }

    func display(title: String) {
        label.text = title
    }
}
