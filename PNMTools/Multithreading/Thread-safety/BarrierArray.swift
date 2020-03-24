//
//  BarrierArray.swift
//  GitHubRepoSearcher
//
//  Created by K Y on 12/19/19.
//  Copyright © 2019 Yu. All rights reserved.
//

import Foundation

/*
 Simple thread-safe array-wrapper with limited functionality
 */

class BarrierArray<T> {
    
    // MARK: - Internal Properties
    
    fileprivate let queue = DispatchQueue(label: "yu.BarrierArray", qos: .utility, attributes: .concurrent)
    fileprivate var _array: [T]
    
    // MARK: - Initializer
    
    init(_ array: [T]) {
        self._array = array
    }
}

extension BarrierArray {

    // MARK: - Array Accessor & Properties

    var array: [T] {
        get {
            queue.sync(flags: .barrier) {
                self._array
            }
        }
        set {
            queue.sync(flags: .barrier) {
                self._array = newValue
            }
        }
    }
    
    var count: Int {
        get {
            queue.sync(flags: .barrier) {
                self._array.count
            }
        }
    }
    
    var isEmpty: Bool {
        get {
            queue.sync(flags: .barrier) {
                self._array.isEmpty
            }
        }
    }
    
    subscript(index: Int) -> T {
        get {
            queue.sync(flags: .barrier) {
                self._array[index]
            }
        }
        set {
            queue.sync(flags: .barrier) {
                self._array[index] = newValue
            }
        }
    }
    
    func append(_ newValue: T) {
        queue.sync(flags: .barrier) {
            _array.append(newValue)
        }
    }
    
    func append(contentsOf newValues: [T]) {
        queue.sync(flags: .barrier) {
            _array.append(contentsOf: newValues)
        }
    }
    
    func removeAll(keepingCapacity: Bool = false) {
        queue.sync(flags: .barrier) {
            array.removeAll(keepingCapacity: keepingCapacity)
        }
    }

}

extension BarrierArray where T: Equatable {
    
    @discardableResult
    func remove(where comparison: (T)->Bool) -> T? {
        var removed: T? = nil
        queue.sync(flags: .barrier) {
            let first = self._array.firstIndex(where: comparison)
            if let i = first {
                removed = _array[i]
                _array.remove(at: i)
            }
        }
        return removed
    }
    
}
