//
//  BaseStoriesListViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class BaseStoriesListViewSpy: BaseStoriesListView {
    var didDisplayLoading = [Bool]()
    var didRequestDisplayEmptyStories: Bool = false
    var didRequestRefreshStories: Bool = false
    var storiesRetrievalError: String?

    var displayEmptyStoriesHandler: (() -> Void)?
    var displayStoriesRetrievalErrorHandler: (() -> Void)?
    var refreshStoriesHandler: (() -> Void)?

    func displayLoading(isLoading: Bool) {
        didDisplayLoading.append(isLoading)
    }

    func displayEmptyStories() {
        didRequestDisplayEmptyStories = true
        displayEmptyStoriesHandler?()
    }

    func displayStoriesRetrievalError(message: String) {
        storiesRetrievalError = message
        displayStoriesRetrievalErrorHandler?()
    }

    func refreshStories() {
        didRequestRefreshStories = true
        refreshStoriesHandler?()
    }
}
