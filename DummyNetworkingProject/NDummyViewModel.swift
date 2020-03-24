//
//  NDummyViewModel.swift
//  DummyNetworkingProject
//
//  Created by K Y on 12/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation
import PNMTools

protocol NDummyViewModelProtocol: DummyViewModelBase {
    func getData(from url: URL)
}

class NDummyViewModel: ViewModelTemplate {
    var networker = NetworkService()
}

extension NDummyViewModel: NDummyViewModelProtocol {
    
    func getData(from url: URL) {
        let completion: (Result<DataType, NetworkError>)->Void = { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .success(let val):
                    // issue persists with type-definition, here
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
        networker.dataTask(url: url,
                           type: DataType.self,
                           params: nil,
                           completion: completion)
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



