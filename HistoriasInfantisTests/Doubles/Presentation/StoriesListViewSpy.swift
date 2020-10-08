//
//  StoriesListViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class StoriesListViewSpy: StoriesListView {
    var presenter: StoriesListPresenter!
    var didRequestDisplayEmptyStories: Bool = false
    var didRequestRefreshStories: Bool = false
    var storiesRetrievalError: String?

    var displayEmptyStoriesHandler: (() -> Void)?
    var refreshStoriesHandler: (() -> Void)?

    func displayEmptyStories() {
        didRequestDisplayEmptyStories = true
        displayEmptyStoriesHandler?()
    }

    func displayStoriesRetrievalError(message: String?) {
        storiesRetrievalError = message
    }

    func refreshStories() {
        didRequestRefreshStories = true
        refreshStoriesHandler?()
    }
}
