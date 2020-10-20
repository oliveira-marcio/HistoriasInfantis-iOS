//
//  StoryViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
@testable import HistoriasInfantis

class StoryViewSpy: StoryView {
    var presenter: StoryPresenter!
    var title: String?
    var image: UIImage?
    var favorited: Bool?
    var error: String?

    var displayImageHandler: (() -> Void)?
    var displayFavoritedHandler: (() -> Void)?

    func display(title: String) {
        self.title = title
    }

    func display(image: UIImage) {
        self.image = image
        displayImageHandler?()
    }

    func display(favorited: Bool) {
        self.favorited = favorited
        displayFavoritedHandler?()
    }

    func display(error: String) {
        self.error = error
        displayFavoritedHandler?()
    }
}
