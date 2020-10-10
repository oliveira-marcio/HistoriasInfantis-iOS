//
//  StoryViewConfigurator.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/10/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class StoryViewConfigurator {
    func configure(storyViewController: StoryViewController, story: Story) {
        let presenter = StoryPresenter(view: storyViewController, story: story)
        storyViewController.presenter = presenter
    }
}
