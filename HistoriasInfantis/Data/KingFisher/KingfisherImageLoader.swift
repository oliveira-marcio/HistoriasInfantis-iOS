//
//  KingfisherImageLoader.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import Kingfisher

struct KingfisherImageLoader: ImageLoader {
    func loadImage(from url: String, into view: UIImageView, placeholder: String) {
        let placeholderImage = UIImage(named: placeholder)
        if let url = URL(string: url) {
            view.kf.indicatorType = .activity
            view.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            view.image = placeholderImage
        }
    }
}
