//
//  String+Validation.swift
//  Debatable
//
//  Created by Brandon Tyler on 4/14/19.
//  Copyright © 2019 RedditiOS. All rights reserved.
//

import Foundation

public extension String {
    
    func isValidPassword() -> Bool {
        return !self.isEmpty
    }
    
    func isValidEmail() -> Bool {
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: self)
    }
}
