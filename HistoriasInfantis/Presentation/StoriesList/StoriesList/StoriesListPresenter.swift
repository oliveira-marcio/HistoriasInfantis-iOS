//
//  StoriesListPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/8/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol StoriesListView: BaseStoriesListView {
    var presenter: StoriesListPresenter! { get set }
}

class StoriesListPresenter: NSObject, BaseStoriesListPresenter {

    private(set) public weak var view: StoriesListView?
    internal(set) public var imageLoader: ImageLoader
    internal(set) public var router: BaseStoriesListViewRouter
    private(set) var displayStoriesListUseCase: DisplayStoriesListUseCase
    private(set) var requestNewStoriesUseCase: RequestNewStoriesUseCase
    private(set) var eventNotifier: EventNotifier

    var stories = [Story]()

    init(view: StoriesListView,
         imageLoader: ImageLoader,
         router: BaseStoriesListViewRouter,
         displayStoriesListUseCase: DisplayStoriesListUseCase,
         requestNewStoriesUseCase: RequestNewStoriesUseCase,
         eventNotifier: EventNotifier) {
        self.view = view
        self.imageLoader = imageLoader
        self.router = router
        self.displayStoriesListUseCase = displayStoriesListUseCase
        self.requestNewStoriesUseCase = requestNewStoriesUseCase
        self.eventNotifier = eventNotifier
    }

    func viewDidLoad() {
        fetchStories()

        eventNotifier.addObserver(self,
                                  selector: #selector(didUpdateFavorites),
                                  name: StoriesRepositoryNotification.didUpdateFavorites.notificationName,
                                  object: nil)
    }

    private func fetchStories() {
        view?.displayLoading(isLoading: true)
        displayStoriesListUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.displayLoading(isLoading: false)
                if result.isSuccess {
                    self?.updateStories(result: result)
                } else {
                    self?.view?.displayEmptyStories()
                    self?.view?.displayStoriesRetrievalError(message: "server_error")
                }
            }
        }
    }

    @objc func didUpdateFavorites() {
        fetchStories()
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
                view?.displayStoriesRetrievalError(message: "persistence_error")
            } else {
                view?.displayStoriesRetrievalError(message: "server_error")
            }
        }
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
