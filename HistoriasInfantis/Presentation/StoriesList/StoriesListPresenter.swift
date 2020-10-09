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
    private(set) var displayStoriesUseCase: DisplayStoriesUseCase
    private(set) var requestNewStoriesUseCase: RequestNewStoriesUseCase

    init(view: StoriesListView,
         displayStoriesUseCase: DisplayStoriesUseCase,
         requestNewStoriesUseCase: RequestNewStoriesUseCase) {
        self.view = view
        self.displayStoriesUseCase = displayStoriesUseCase
        self.requestNewStoriesUseCase = requestNewStoriesUseCase
    }

    func viewDidLoad() {
        displayStoriesUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                if result.isSuccess {
                    self?.view?.refreshStories()
                } else {
                    self?.view?.displayEmptyStories()
                    self?.view?.displayStoriesRetrievalError(message: "Server Error")
                }
            }
        }
    }

    func refresh() {
        requestNewStoriesUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                if result.isSuccess {
                    self?.view?.refreshStories()
                } else {
                    self?.view?.displayStoriesRetrievalError(message: "Server Error")
                }
            }
        }
    }
}
