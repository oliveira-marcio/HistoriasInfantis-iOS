//
//  StoriesListViewConfigurator.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class StoriesListViewConfigurator {
    func configure(storiesViewController: StoriesViewController) {
        let presenter = StoriesListPresenter(view: storiesViewController,
                                             displayStoriesUseCase: SceneDelegate.appEnvironment.dependencies.displayStoriesUseCase,
                                             requestNewStoriesUseCase: SceneDelegate.appEnvironment.dependencies.requestNewStoriesUseCase)

        storiesViewController.presenter = presenter
    }
}
