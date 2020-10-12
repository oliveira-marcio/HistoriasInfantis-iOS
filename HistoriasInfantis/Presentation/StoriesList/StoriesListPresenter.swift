//
//  StoriesListPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class StoriesListPresenter: BaseStoriesListPresenter {

    internal(set) public weak var view: StoriesListView?
    internal(set) public var router: StoriesListViewRouter
    private(set) var displayStoriesListUseCase: DisplayStoriesListUseCase
    private(set) var requestNewStoriesUseCase: RequestNewStoriesUseCase

    var stories = [Story]()

    init(view: StoriesListView,
         router: StoriesListViewRouter,
         displayStoriesListUseCase: DisplayStoriesListUseCase,
         requestNewStoriesUseCase: RequestNewStoriesUseCase) {
        self.view = view
        self.router = router
        self.displayStoriesListUseCase = displayStoriesListUseCase
        self.requestNewStoriesUseCase = requestNewStoriesUseCase
    }

    func viewDidLoad() {
        view?.displayLoading(isLoading: true)
        displayStoriesListUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.displayLoading(isLoading: false)
                if result.isSuccess {
                    self?.updateStories(result: result)
                } else {
                    self?.view?.displayEmptyStories()
                    self?.view?.displayStoriesRetrievalError(message: "Server Error")
                }
            }
        }
    }

    func refresh() {
        view?.displayLoading(isLoading: true)
        requestNewStoriesUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.displayLoading(isLoading: false)
                if result.isSuccess {
                    self?.updateStories(result: result)
                } else {
                    self?.handleRefreshError(result: result)
                }
            }
        }
    }

    private func handleRefreshError(result: Result<[Story]>) {
        if case .failure(let resultError) = result,
            let error = resultError as? StoriesRepositoryError {
            if error == .unableToSave {
                updateStories(result: result)
                view?.displayStoriesRetrievalError(message: "Persistence Error")
            } else {
                view?.displayStoriesRetrievalError(message: "Server Error")
            }
        }
    }

    private func updateStories(result: Result<[Story]>) {
        if let stories = try? result.dematerialize() {
            self.stories = stories
            view?.refreshStories()
        } else {
            stories = []
            view?.displayEmptyStories()
        }
    }
}
