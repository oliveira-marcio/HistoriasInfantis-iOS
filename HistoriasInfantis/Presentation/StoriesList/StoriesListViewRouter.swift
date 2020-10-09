//
//  StoriesListViewRouter.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import UIKit

protocol StoriesListViewRouter: ViewRouter {
    func navigateToStory(_ story: Story)
}

enum StoriesViewSegue: String {
    case toStory = "toStory"
}

class StoriesListViewRouterImplementation: StoriesListViewRouter {
    fileprivate weak var storiesListViewController: StoriesListViewController?

    init(storiesListViewController: StoriesListViewController) {
        self.storiesListViewController = storiesListViewController
    }

    func navigateToStory(_ story: Story) {

    }

    func prepare(for segue: Any, sender: Any?) {

    }
}
