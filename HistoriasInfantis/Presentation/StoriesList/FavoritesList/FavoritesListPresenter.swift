//
//  FavoritesListPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol FavoritesListView: BaseStoriesListView {
    var presenter: FavoritesListPresenter! { get set }
}

class FavoritesListPresenter: NSObject, BaseStoriesListPresenter {

    internal(set) public weak var view: FavoritesListView?
    internal(set) public var imageLoader: ImageLoader
    internal(set) public var router: BaseStoriesListViewRouter
    private(set) var displayFavoritesListUseCase: DisplayFavoritesListUseCase
    private(set) var eventNotifier: EventNotifier

    var stories = [Story]()

    init(view: FavoritesListView,
         imageLoader: ImageLoader,
         router: BaseStoriesListViewRouter,
         displayFavoritesListUseCase: DisplayFavoritesListUseCase,
         eventNotifier: EventNotifier) {
        self.view = view
        self.imageLoader = imageLoader
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
        if let stories = try? result.dematerialize(), !stories.isEmpty {
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
