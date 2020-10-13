//
//  FavoritesListViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/13/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController, FavoritesListView {

    var presenter: FavoritesListPresenter!
    var tableViewDelegate: BaseStoriesListDelegate!

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noStoriesView: UIView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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

    // MARK: - IBActions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        presenter.router.prepare(for: segue, sender: sender)
    }
}
