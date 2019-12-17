//
//  UITextField+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension UITextField {
    
    func handleTextChange(_ target: Any,
                          _ selector: Selector) {
        self.addTarget(target, action: selector, for: .editingChanged)
        if let del = target as? UITextFieldDelegate {
            delegate = del
        }
    }
    
}
