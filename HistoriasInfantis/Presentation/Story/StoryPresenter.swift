//
//  StoryPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol StoryView: class {
    var presenter: StoryPresenter! { get set }
    func display(story: Story)
}

class StoryPresenter {

    private(set) weak var view: StoryView?
    private(set) public var story: Story

    init(view: StoryView, story: Story) {
        self.view = view
        self.story = story
    }

    func viewDidLoad() {
        DispatchQueue.main.async {
            self.view?.display(story: self.story)
        }
    }
}
