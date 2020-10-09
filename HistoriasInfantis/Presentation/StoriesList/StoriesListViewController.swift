//
//  StoriesListViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StoriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoriesListView {

    var presenter: StoriesListPresenter!

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noStoriesView: UIView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
    }

    private func setupTableView() {
        tableView.tableHeaderView = tableHeaderView
    }

    // MARK: - CallHistoryView

    func displayLoading(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        refreshButton.isEnabled = !isLoading
    }

    func displayEmptyStories() {
        tableView.backgroundView = noStoriesView
        tableView.isScrollEnabled = false
    }

    func displayStoriesRetrievalError(message: String?) {
        print("ERROR")
    }

    func refreshStories() {
        tableView.reloadData()
        tableView.isScrollEnabled = true
        tableView.backgroundView = nil
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

    // MARK: - IBActions

    @IBAction func refreshTapped(_ sender: Any) {
        presenter.refresh()
    }
}
