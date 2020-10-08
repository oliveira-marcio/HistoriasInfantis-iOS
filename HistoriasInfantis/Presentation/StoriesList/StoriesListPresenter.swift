//
//  StoriesListPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol StoriesListView: class {
    var presenter: StoriesListPresenter! { get set }

    func displayEmptyStories()
    func displayStoriesRetrievalError(message: String?)
    func refreshStories()
}

protocol StoryCellView: class {
}

class StoriesListPresenter {

    private(set) weak var view: StoriesListView?
    private(set) var storiesRepository: StoriesRepository

    init(view: StoriesListView, storiesRepository: StoriesRepository) {
        self.view = view
        self.storiesRepository = storiesRepository
    }

    func viewDidLoad() {
        storiesRepository.fetchAll { result in

        }
    }
}
