//
//  FavoritesListPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class FavoritesListPresenter: NSObject, BaseStoriesListPresenter {

    internal(set) public weak var view: StoriesListView?
    internal(set) public var router: StoriesListViewRouter
    private(set) var displayFavoritesListUseCase: DisplayFavoritesListUseCase
    private(set) var eventNotifier: EventNotifier

    var stories = [Story]()

    init(view: StoriesListView,
         router: StoriesListViewRouter,
         displayFavoritesListUseCase: DisplayFavoritesListUseCase,
         eventNotifier: EventNotifier) {
        self.view = view
        self.router = router
        self.displayFavoritesListUseCase = displayFavoritesListUseCase
        self.eventNotifier = eventNotifier
    }

    func viewDidLoad() {
        fetchFavorites()

        eventNotifier.addObserver(self,
                                  selector: #selector(didUpdateFavorites),
                                  name: StoriesRepositoryNotification.didUpdateFavorites.notificationName,
                                  object: nil)
    }

    private func fetchFavorites() {
        view?.displayLoading(isLoading: true)
        displayFavoritesListUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.displayLoading(isLoading: false)
                if result.isSuccess {
                    self?.updateStories(result: result)
                } else {
                    self?.view?.displayEmptyStories()
                    self?.view?.displayStoriesRetrievalError(message: "Persistence Error")
                }
            }
        }
    }

    @objc func didUpdateFavorites() {
        fetchFavorites()
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

    deinit {
        eventNotifier.removeObserver(self)
    }
}
