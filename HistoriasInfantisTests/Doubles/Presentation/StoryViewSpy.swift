//
//  StoryViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

class StoryViewSpy: StoryView {
    var presenter: StoryPresenter!
    var title: String?
    var image: Data?

    var displayImageHandler: (() -> Void)?

    func display(title: String) {
        self.title = title
    }

    func display(image: Data) {
        self.image = image
        displayImageHandler?()
    }
}
