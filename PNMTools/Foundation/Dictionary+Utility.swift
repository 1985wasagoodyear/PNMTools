//
//  Dictionary+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

extension Dictionary where Value == Int {
    mutating public func decrement(_ key: Key, by val: Int = 1, removeIfEqual: Bool = false) {
        guard let count = self[key] else { return }
        if removeIfEqual == true && count == val {
            self.removeValue(forKey: key)
        }
        else {
            self[key] = count - val
        }
    }
}
