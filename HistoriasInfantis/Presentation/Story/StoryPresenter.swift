//
//  StoryPresenter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol StoryView: class {
    var presenter: StoryPresenter! { get set }
    func display(title: String)
    func display(image: Data)
    func display(favorited: Bool)
    func display(error: String)
}

protocol ParagraphCellView: class {
    func display(text: String)
    func display(author: String)
    func display(end: String)
    func display(image: Data)
}

class StoryPresenter {

    private(set) weak var view: StoryView?
    private(set) public var story: Story
    private(set) public var imageLoader: ImageLoader
    private(set) public var toggleFavoriteStoryUseCase: ToggleFavoriteStoryUseCase

    init(view: StoryView,
         story: Story,
         imageLoader: ImageLoader,
         toggleFavoriteStoryUseCase: ToggleFavoriteStoryUseCase) {
        self.view = view
        self.story = story
        self.imageLoader = imageLoader
        self.toggleFavoriteStoryUseCase = toggleFavoriteStoryUseCase
    }

    func viewDidLoad() {
        view?.display(title: story.title)
        view?.display(favorited: story.favorite)
    }

    func getParagraphsCount() -> Int {
        return story.paragraphs.count
    }

    func getParagraphType(for row: Int) -> String {
        return story.paragraphs[row].type
    }

    func configureCell(_ view: ParagraphCellView, for row: Int) {
        switch story.paragraphs[row] {
        case .text(let text): view.display(text: text)
        case .author(let author): view.display(author: author)
        case .end(let end): view.display(end: end)
        case .image(let imageUrl): imageLoader.getImage(from: imageUrl) { image in
                if let image = image {
                    view.display(image: image)
                }
            }
        }
    }

    func toggleFavorite() {
        toggleFavoriteStoryUseCase.invoke(story: story) { result in
            DispatchQueue.main.async {
                if result.isSuccess, let story = try? result.dematerialize() {
                    self.view?.display(favorited: story.favorite)
                } else {
                    self.view?.display(error: "Toggle favorite error")
                }
            }
        }
    }
}
