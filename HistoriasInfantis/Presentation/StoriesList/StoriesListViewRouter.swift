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
        DispatchQueue.main.async {
            self.storiesListViewController?.performSegue(
                withIdentifier: StoriesViewSegue.toStory.rawValue,
                sender: story
            )
        }
    }

    func prepare(for segue: Any, sender: Any?) {
        guard let segue = segue as? UIStoryboardSegue else { return }

        switch segue.identifier {
        case StoriesViewSegue.toStory.rawValue:
            guard let storyViewController = segue.destination as? StoryViewController,
                let story = sender as? Story else { return }
            let configurator = StoryViewConfigurator()
            configurator.configure(storyViewController: storyViewController, story: story)
        default: break
        }
    }
}
