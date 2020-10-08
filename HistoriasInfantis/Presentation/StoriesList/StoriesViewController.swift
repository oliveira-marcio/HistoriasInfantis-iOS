//
//  ViewController.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!

    let textList = ["Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3","Test 1", "Test 2", "Test 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StoriesHeaderView.nib, forHeaderFooterViewReuseIdentifier: StoriesHeaderView.reuseIdentifier)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section > 0 ? textList.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryViewCell.reuseIdentifier, for: indexPath) as! StoryViewCell
        cell.label.text = textList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section > 0 ? nil : (tableView.dequeueReusableHeaderFooterView(
            withIdentifier: StoriesHeaderView.reuseIdentifier)
            as! StoriesHeaderView)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section > 0 ? 0 : 100
    }
}

