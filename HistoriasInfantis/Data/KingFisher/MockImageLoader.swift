//
//  MockImageLoader.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

struct MockImageLoader: ImageLoader {
    func loadImage(from url: String, into view: UIImageView, placeholder: String) {
        view.image = UIImage(systemName: "book.fill")
    }

    func loadImage(from url: String, into view: UIImageView) {
        view.image = UIImage(systemName: "book.fill")
    }
}
