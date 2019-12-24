//
//  Observable.swift
//  SimpleTwoWayBinding
//
//  Created by Manish Katoch on 11/26/17.
//

/**********************************************
 
 Retrived from https://codeburst.io/swift-mvvm-two-way-binding-win-b447edc55ff5

 Marked-up by Kevin Yu
 on 12/24/19.
 
 Not sure how much I like this... needs additional boilerplate from his document
 
**********************************************/

import Foundation

public class Observable<ObservedType> {
    public typealias Observer = (_ observable: Observable<ObservedType>, ObservedType) -> Void
    
    // MARK: - Properties
    
    private var observers: [Observer]
    
    public var value: ObservedType? {
        didSet {
            guard let value = value else { return }
            notifyObservers(value)
        }
    }
    
    // MARK: - Initializers
    
    public init(_ value: ObservedType? = nil) {
        self.value = value
        observers = []
    }
    
    // MARK: - Bind & Notify Methods
    
    public func bind(observer: @escaping Observer) {
        self.observers.append(observer)
    }
    
    private func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { [unowned self] (observer) in
            observer(self, value)
        }
    }
}
