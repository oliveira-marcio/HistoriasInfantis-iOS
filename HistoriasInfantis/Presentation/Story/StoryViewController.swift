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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    // MARK: - StoryView

    func display(title: String) {
        print(title)
    }

    func display(image: Data) {

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
}
