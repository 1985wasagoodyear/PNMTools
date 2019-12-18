//
//  String+Utility.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

extension String {
    public subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

