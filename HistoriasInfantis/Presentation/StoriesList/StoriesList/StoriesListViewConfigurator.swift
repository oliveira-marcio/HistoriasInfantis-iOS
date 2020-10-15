//
//  StoriesListViewConfigurator.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class StoriesListViewConfigurator {
    func configure(storiesListViewController: StoriesListViewController) {
        let router = BaseStoriesListViewRouterImplementation(storiesListViewController: storiesListViewController)
        let presenter = StoriesListPresenter(view: storiesListViewController,
                                             router: router,
                                             displayStoriesListUseCase: SceneDelegate.appEnvironment.dependencies.displayStoriesUseCase,
                                             requestNewStoriesUseCase: SceneDelegate.appEnvironment.dependencies.requestNewStoriesUseCase,
                                             eventNotifier: SceneDelegate.appEnvironment.dependencies.eventNotifier)

        storiesListViewController.presenter = presenter
    }
}
