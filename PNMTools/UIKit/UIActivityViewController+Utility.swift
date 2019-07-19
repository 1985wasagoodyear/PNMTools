//
//  UIActivityViewController+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(text: String) {
        let alert = UIAlertController(title: text,
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",
                               style: .default,
                               handler: nil)
        alert.addAction(ok)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}

