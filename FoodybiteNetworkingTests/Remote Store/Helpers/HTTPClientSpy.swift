//
//  HTTPClientSpy.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation
import SharedAPI

class HTTPClientSpy: HTTPClient {
    private(set) var urlRequests = [URLRequest]()
    var result: Result<(Data, HTTPURLResponse), NSError>?
    
    func send(_ urlRequest: URLRequest) throws -> (data: Data, response: HTTPURLResponse) {
        urlRequests.append(urlRequest)
        
        if let result = result {
            switch result {
            case let .failure(error):
                throw error
            case let .success(result):
                return result
            }
        }
        
        throw NSError(domain: "error", code: 1)
    }
}
