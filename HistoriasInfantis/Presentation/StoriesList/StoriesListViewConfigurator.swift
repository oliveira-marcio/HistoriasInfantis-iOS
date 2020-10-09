//
//  StoriesListViewConfigurator.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class StoriesListViewConfigurator {
    func configure(storiesListViewController: StoriesListViewController) {
        let router = StoriesListViewRouterImplementation(storiesListViewController: storiesListViewController)
        let presenter = StoriesListPresenter(view: storiesListViewController,
                                             router: router,
                                             displayStoriesUseCase: SceneDelegate.appEnvironment.dependencies.displayStoriesUseCase,
                                             requestNewStoriesUseCase: SceneDelegate.appEnvironment.dependencies.requestNewStoriesUseCase)

        storiesListViewController.presenter = presenter
    }
}