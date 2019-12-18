//
//  Notification+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension NotificationCenter {
    
    public static func registerKeyboardHandler(_ target: Any,
                                        willShow: Selector,
                                        willHide: Selector,
                                        object: Any? = nil) {
        NotificationCenter.default.addObserver(target,
                                               selector: willShow,
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: object)
        NotificationCenter.default.addObserver(target,
                                               selector: willHide,
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: object)
    }
    
    public static func unregisterKeyboardHandler(_ target: Any,
                                          object: Any? = nil) {
        NotificationCenter.default.removeObserver(target,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: object)
        NotificationCenter.default.removeObserver(target,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: object)
    }
    
}
