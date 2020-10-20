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
    var reuseIdentifiers: [String: String]!

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

    func display(image: UIImage) {
        tableHeaderImageView.image = image
    }

    func display(favorited: Bool) {
        favoriteButton.activeColor = UIColor(named: favorited ? "Favorite" : "Accent")
    }

    func display(error: String) {
        presentAlert(withTitle: "error", message: error)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getParagraphsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataType = presenter.getParagraphType(for: indexPath.row)

        guard let reuseIdentifier = reuseIdentifiers[dataType],
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ParagraphCellView
            else {
                return UITableViewCell()
        }

        presenter.configureCell(cell, for: indexPath.row)
        
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    // MARK: - IBActions

    @IBAction func favoriteTapped(_ sender: Any) {
        presenter.toggleFavorite()
    }
}
