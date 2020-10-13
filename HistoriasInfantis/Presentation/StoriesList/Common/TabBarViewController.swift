//
//  TabBarViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs(viewControllers: self.viewControllers)
    }

    private func configureTabs(viewControllers: [UIViewController]?) {
        guard let viewControllers = viewControllers else { return }

        viewControllers.forEach { viewController in
            if let navigationController = viewController as? UINavigationController,
                let storiesListVC = navigationController.topViewController as? StoriesListViewController {
                let configurator = StoriesListViewConfigurator()
                configurator.configure(storiesListViewController: storiesListVC)
            } else if let navigationController = viewController as? UINavigationController,
                let favoritesListVC = navigationController.topViewController as? FavoritesListViewController {
                let configurator = FavoritesListViewConfigurator()
                configurator.configure(favoritesListViewController: favoritesListVC)
            }
        }
    }
}
