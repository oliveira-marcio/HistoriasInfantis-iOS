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
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
