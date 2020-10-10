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

    init(view: StoryView, story: Story) {
        self.view = view
        self.story = story
    }

    func viewDidLoad() {
        view?.display(title: story.title)
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
        case .image(_): view.display(image: Data())
        }
    }
}
