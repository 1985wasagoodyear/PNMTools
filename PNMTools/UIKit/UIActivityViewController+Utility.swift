//
//  UIActivityViewController+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(text: String, message: String? = nil) {
        let alert = UIAlertController(title: text,
                                      message: message,
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

