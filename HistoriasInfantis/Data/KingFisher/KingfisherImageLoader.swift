//
//  KingfisherImageLoader.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/18/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import Kingfisher

struct KingfisherImageLoader: ImageLoader {
    func getImage(from url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image.pngData())
            case .failure(_):
                completion(nil)
            }
        }
    }
}
