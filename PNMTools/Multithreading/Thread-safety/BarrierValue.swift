//
//  BarrierValue.swift
//  GitHubRepoSearcher
//
//  Created by K Y on 12/19/19.
//  Copyright © 2019 Yu. All rights reserved.
//

import Foundation

/*
 Simple thread-safe value-wrapper,
 
 Based on Apple's WWDC 2016 presentation,
 "Concurrent Programming With GCD in Swift 3"
 - https://developer.apple.com/videos/play/wwdc2016/720/
 
 */

class BarrierValue<T> {
    
    // MARK: - Internal Properties
    
    fileprivate let queue = DispatchQueue(label: "yu.BarrierArray", qos: .utility, attributes: .concurrent)
    fileprivate var _val: T
    
    // MARK: - Initializer
    
    init(_ val: T) {
        _val = val
    }
    
}

extension BarrierValue {
    
    // MARK: - Accessors & Properties
    
    var value: T {
        get {
            queue.sync(flags: .barrier) {
                self._val
            }
        }
        set {
            queue.sync(flags: .barrier) {
                self._val = newValue
            }
        }
    }
    
}
