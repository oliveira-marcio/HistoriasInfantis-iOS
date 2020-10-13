//
//  StoriesListViewRouterSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class StoriesListViewRouterSpy: BaseStoriesListViewRouter {

    var story: Story?
    var navigateToStoryViewCompletion: (() -> Void)?

    func navigateToStory(_ story: Story) {
        self.story = story
        navigateToStoryViewCompletion?()
    }
}
