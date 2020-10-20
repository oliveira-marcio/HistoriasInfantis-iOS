//
//  BaseStoriesListPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import UIKit

protocol BaseStoriesListView: class {
    func displayLoading(isLoading: Bool)
    func displayEmptyStories()
    func displayStoriesRetrievalError(message: String?)
    func refreshStories()
}

protocol StoryCellView: class {
    func display(title: String)
    func display(image: UIImage)
    func display(image named: String)
    func display(imageLoading: Bool)
}

protocol BaseStoriesListPresenter: class {
    var imageLoader: ImageLoader { get set }
    var router: BaseStoriesListViewRouter { get set }
    var stories: [Story] { get set }

    func viewDidLoad()
    func configureStoryCellView(_ storyView: StoryCellView, for row: Int)
    func showStory(at row: Int)
}

extension BaseStoriesListPresenter {
    func configureStoryCellView(_ storyView: StoryCellView, for row: Int) {
        storyView.display(title: stories[row].title)
        storyView.display(imageLoading: true)
        imageLoader.getImage(from: stories[row].imageUrl) { image in
            storyView.display(imageLoading: false)
            if let image = image {
                storyView.display(image: image)
            } else {
                storyView.display(image: "placeholder")
            }
        }
    }

    func showStory(at row: Int) {
        router.navigateToStory(stories[row])
    }
}
