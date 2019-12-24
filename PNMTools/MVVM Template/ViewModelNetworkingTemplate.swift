//
//  ViewModelNetworkingTemplate.swift
//  PNMTools
//
//  Created by K Y on 12/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

// presently, none of this should actually be used as-is, out-of-the-box

import Foundation

protocol ViewModelNetworkingTemplateProtocol: ViewModelTemplateProtocol {
    
    // issue with this...?
    func getData(from url: URL)
}


class ViewModelNetworkingTemplate: ViewModelTemplate {
    
    var networker = NetworkService()
    
}

extension ViewModelNetworkingTemplate: ViewModelNetworkingTemplateProtocol {
    
    // issue with this...?
    func getData(from url: URL) {
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
