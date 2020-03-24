//
//  DummyViewModel.swift
//  DummyNetworkingProject
//
//  Created by K Y on 12/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation
import PNMTools

/// basic Protocol template & definition
/// sample model definition
public struct DummyModel: Decodable {
    let title: String
}

/// sample error definition
public enum ViewModelError: Error {
    case empty
}

public protocol DummyViewModelBase: ViewModelBaseProtocol where DataType == [DummyModel] {
    var datum: Result<[DummyModel], Error> { get }
    func bind(_ update: @escaping (Result<[DummyModel], Error>) -> Void)
    func bindAndFire(_ update: @escaping (Result<[DummyModel], Error>) -> Void)
    func unbind()
}

/// sample ViewModelTemplate
open class ViewModelTemplate: DummyViewModelBase {
    
    // MARK: - Properties
    
    public var datum: Result<[DummyModel], Error> {
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
    
    public func bind(_ update: @escaping (Result<[DummyModel], Error>)->Void) {
        observers.append(update)
    }
    
    public func bindAndFire(_ update: @escaping (Result<[DummyModel], Error>)->Void) {
        observers.append(update)
        update(datum)
    }
    
    public func unbind() {
        observers.removeAll(keepingCapacity: true)
    }
    
}

