//
//  ImageLoader.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

protocol ImageLoader {
    func getImage(from url: String, completion: @escaping (UIImage?) -> Void) 
}
