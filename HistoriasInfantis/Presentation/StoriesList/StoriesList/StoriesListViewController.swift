//
//  StoriesListViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StoriesListViewController: UIViewController, StoriesListView {

    var presenter: StoriesListPresenter!
    var tableViewDelegate: BaseStoriesListDelegate!

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
        tableViewDelegate = BaseStoriesListDelegate(presenter: presenter)
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        tableView.tableHeaderView = tableHeaderView
    }

    // MARK: - BaseStoriesListView

    func displayLoading(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        refreshButton.isEnabled = !isLoading
    }

    func displayEmptyStories() {
        tableView.backgroundView = noStoriesView
        tableView.isScrollEnabled = false
        tableView.reloadData()
    }

    func displayStoriesRetrievalError(message: String) {
        presentAlert(withTitle: "error", message: message.localized())
    }

    func refreshStories() {
        tableView.reloadData()
        tableView.isScrollEnabled = true
        tableView.backgroundView = nil
    }

    // MARK: - IBActions

    @IBAction func refreshTapped(_ sender: Any) {
        presenter.refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        presenter.router.prepare(for: segue, sender: sender)
    }
}

