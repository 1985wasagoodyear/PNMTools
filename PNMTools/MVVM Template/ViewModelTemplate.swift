//
//  ViewModelTemplate.swift
//  PNMTools
//
//  Created by K Y on 12/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

/// basic Protocol template & definition
public protocol ViewModelTemplateProtocol: class {
    typealias DataResult = Result<DataType, Error>
    typealias ViewModelUpdateHandler = (DataResult)->Void
    
    associatedtype DataType
    var datum: DataResult { get }
    func bind(_ update: @escaping ViewModelUpdateHandler)
    func bindAndFire(_ update: @escaping ViewModelUpdateHandler)
    func unbind()
}

/// sample model definition
public struct SampleModel: Decodable { }

/// sample error definition
public enum ViewModelError: Error {
    case empty
}

/// sample ViewModelTemplate
open class ViewModelTemplate: ViewModelTemplateProtocol {
    
    // TODO: - perform type-erasure here
    public typealias DataType = [SampleModel]
    
    // MARK: - Properties
    
    public var datum: Result<DataType, Error> {
        didSet {
            observers.forEach { $0(datum) }
        }
    }
    var observers: [ViewModelUpdateHandler]
    
    // MARK: - Initializers & Deinit
    
    public init() {
        datum = .failure(ViewModelError.empty)
        observers = []
    }
    
    deinit { }
    
    // MARK: - Binding Methods
    
    public func bind(_ update: @escaping ViewModelUpdateHandler) {
        observers.append(update)
    }
    
    public func bindAndFire(_ update: @escaping ViewModelUpdateHandler) {
        observers.append(update)
        update(datum)
    }

    public func unbind() {
        observers.removeAll(keepingCapacity: true)
    }
    
}



