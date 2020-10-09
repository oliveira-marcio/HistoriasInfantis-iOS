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

    func displayLoading(isLoading: Bool)
    func displayEmptyStories()
    func displayStoriesRetrievalError(message: String?)
    func refreshStories()
}

protocol StoryCellView: class {
    func display(image from: Data)
    func display(image named: String)
    func display(title: String)
}

class StoriesListPresenter {

    private(set) weak var view: StoriesListView?
    private(set) public var router: StoriesListViewRouter
    private(set) var displayStoriesUseCase: DisplayStoriesUseCase
    private(set) var requestNewStoriesUseCase: RequestNewStoriesUseCase

    var stories = [Story]()

    init(view: StoriesListView,
         router: StoriesListViewRouter,
         displayStoriesUseCase: DisplayStoriesUseCase,
         requestNewStoriesUseCase: RequestNewStoriesUseCase) {
        self.view = view
        self.router = router
        self.displayStoriesUseCase = displayStoriesUseCase
        self.requestNewStoriesUseCase = requestNewStoriesUseCase
    }

    func viewDidLoad() {
        view?.displayLoading(isLoading: true)
        displayStoriesUseCase.invoke { [weak self] result in
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
                    self?.view?.displayStoriesRetrievalError(message: "Server Error")
                }
            }
        }
    }

    public func configureStoryCellView(_ storyView: StoryCellView, for row: Int) {
        storyView.display(title: stories[row].title)
    }

    private func updateStories(result: Result<[Story]>) {
        if let stories = try? result.dematerialize() {
            self.stories = stories
            view?.refreshStories()
        }
    }

    public func showStory(at row: Int) {
        router.navigateToStory(stories[row])
    }
}
