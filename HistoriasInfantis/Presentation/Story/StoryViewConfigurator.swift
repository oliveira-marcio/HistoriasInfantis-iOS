//
//  StoryViewConfigurator.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/10/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class StoryViewConfigurator {
    func configure(storyViewController: StoryViewController, story: Story) {
        let presenter = StoryPresenter(view: storyViewController,
                                       story: story,
                                       imageLoader: SceneDelegate.appEnvironment.dependencies.gateways.imageLoader,
                                       toggleFavoriteStoryUseCase: SceneDelegate.appEnvironment.dependencies.toggleFavoriteStoryUseCase)

        let reuseIdentifiers: [String: String] = [
               Story.Paragraph.text("").type : TextParagraphViewCell.reuseIdentifier,
               Story.Paragraph.image("").type : ImageParagraphViewCell.reuseIdentifier,
               Story.Paragraph.end("").type : EndParagraphViewCell.reuseIdentifier,
               Story.Paragraph.author("").type : AuthorParagraphViewCell.reuseIdentifier
           ]

        storyViewController.presenter = presenter
        storyViewController.reuseIdentifiers = reuseIdentifiers
    }
}
