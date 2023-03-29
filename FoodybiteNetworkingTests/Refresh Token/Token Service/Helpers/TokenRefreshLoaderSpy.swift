//
//  TokenRefreshLoaderSpy.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Foundation
import FoodybiteNetworking

class TokenRefreshLoaderSpy: ResourceLoader {
    private let response: AuthToken
    var requests = [URLRequest]()
    
    init(response: AuthToken) {
        self.response = response
    }
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        requests.append(urlRequest)
        return response as! T
    }
}
