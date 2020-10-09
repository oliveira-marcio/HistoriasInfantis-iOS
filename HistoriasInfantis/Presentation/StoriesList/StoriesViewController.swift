//
//  ViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoriesListView {

    var presenter: StoriesListPresenter!

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
    }

    private func setupTableView() {
        tableView.register(StoriesHeaderView.nib,
                           forHeaderFooterViewReuseIdentifier: StoriesHeaderView.reuseIdentifier)
    }

    // MARK: - CallHistoryView

    func displayEmptyStories() {
        print("EMPTY")
    }

    func displayStoriesRetrievalError(message: String?) {
        print("ERROR")
    }

    func refreshStories() {
        tableView.reloadData()
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: StoriesHeaderView.reuseIdentifier)
            as! StoriesHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}

