//
//  FavoritesListViewConfigurator.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/13/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

class FavoritesListViewConfigurator {
    func configure(favoritesListViewController: FavoritesListViewController) {
        let router = BaseStoriesListViewRouterImplementation(storiesListViewController: favoritesListViewController)
        let presenter = FavoritesListPresenter(view: favoritesListViewController,
                                               imageLoader: SceneDelegate.appEnvironment.dependencies.gateways.imageLoader,
                                               router: router,
                                               displayFavoritesListUseCase: SceneDelegate.appEnvironment.dependencies.displayFavoritesListUseCase,
                                               eventNotifier: SceneDelegate.appEnvironment.dependencies.eventNotifier)

        favoritesListViewController.presenter = presenter
    }
}
