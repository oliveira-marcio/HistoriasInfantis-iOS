//
//  StoryViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/10/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoryView {

    var presenter: StoryPresenter!

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var tableHeaderImageView: UIImageView!
    @IBOutlet weak var tableHeaderLabel: UILabel!
    @IBOutlet weak var favoriteButton: FloatActionButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = tableHeaderView

        presenter.viewDidLoad()
    }

    // MARK: - StoryView

    func display(title: String) {
        tableHeaderLabel.text = title
    }

    func display(image: Data) {

    }

    func display(favorited: Bool) {
        print(favorited)
    }

    func display(error: String) {

    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getParagraphsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParagraphViewCell.reuseIdentifier, for: indexPath) as! ParagraphCellView
        presenter.configureCell(cell, for: indexPath.row)
        return cell as! UITableViewCell
    }

    // MARK: - IBActions

    @IBAction func favoriteTapped(_ sender: Any) {
        print("Favorited!")
        presenter.toggleFavorite()
    }
}
