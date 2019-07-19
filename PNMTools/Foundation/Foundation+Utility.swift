//
//  Foundation+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

public extension Data {
    var ns: NSData {
        return NSData(data: self)
    }
}

public extension String {
    var ns: NSString {
        return NSString(string: self)
    }
}
