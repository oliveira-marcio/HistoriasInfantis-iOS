//
//  BaseStoriesViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/13/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class BaseStoriesListDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {

    var presenter: BaseStoriesListPresenter!

    init(presenter: BaseStoriesListPresenter) {
        self.presenter = presenter
    }
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryViewCell.reuseIdentifier, for: indexPath) as! StoryViewCell
        presenter.configureStoryCellView(cell, for: indexPath.row)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showStory(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
