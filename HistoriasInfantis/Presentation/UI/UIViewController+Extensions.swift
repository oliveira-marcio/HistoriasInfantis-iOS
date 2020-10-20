//
//  UIViewController+Extensions.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/20/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert(withTitle title:String, message: String) {
        let alert = UIAlertController(title: title.localized(),
                                      message: message.localized(),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss".localized(),
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
