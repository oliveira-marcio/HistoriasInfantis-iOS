//
//  StoryViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class StoryViewSpy: StoryView {
    var presenter: StoryPresenter!
    var story: Story?
    var displayStoryHandler: (() -> Void)?

    func display(story: Story) {
        self.story = story
        displayStoryHandler?()
    }
}
