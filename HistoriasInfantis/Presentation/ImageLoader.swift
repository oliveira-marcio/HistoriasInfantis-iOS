//
//  ImageLoader.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

protocol ImageLoader {
    func loadImage(from url: String, into view: UIImageView, placeholder: String)
    func loadImage(from url: String, into view: UIImageView)
}
