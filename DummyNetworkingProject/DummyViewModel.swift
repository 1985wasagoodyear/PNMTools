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

/// sample ViewModelTemplate
open class ViewModelTemplate: ViewModelTemplateProtocol {
    
    public typealias DataType = [DummyModel]
    
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

protocol NDummyViewModelProtocol: ViewModelTemplateProtocol {
    
    // issue with this...?
    func getData(from url: URL)
}


class NDummyViewModel: ViewModelTemplate {
    
    var networker = NetworkService()
    
}

extension NDummyViewModel: NDummyViewModelProtocol {
    
    // issue with this...?
    func getData(from url: URL) {
        datum = Result.success([])
        networker.dataTask(url: url,
                           type: DataType.self,
                           params: nil) { [weak self] (result) in
                            guard let self = self else { return }
                            switch result {
                                case .success(let val):
                                    if let val = val as? DataType {
                                        self.success(val: val)
                                    }
                                    else {
                                        fatalError("Where did we go wrong")
                                }
                                case .failure(let err):
                                    self.handle(error: err)
                            }
        }
    }
    
    func success(val: DataType) {
        datum = .success(val)
    }
    
    func handle(error: NetworkError) {
        switch error {
            case .unknownError:
                fallthrough
            case .connectionError:
                fallthrough
            case .invalidCredentials:
                fallthrough
            case .invalidRequest:
                fallthrough
            case .notFound:
                fallthrough
            case .invalidResponse/*(let err)*/:
                fallthrough
            case .serverError:
                fallthrough
            case .serverUnavailable:
                fallthrough
            case .timeOut:
                fallthrough
            case .unsupportedURL:
                fallthrough
            case .emptyResult:
                fallthrough
            default:
                self.datum = .failure(ViewModelError.empty)
        }
    }
}



