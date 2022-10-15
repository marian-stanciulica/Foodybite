//
//  ResourceLoaderSpy.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation
@testable import FoodybiteNetworking

class ResourceLoaderSpy: ResourceLoader {
    private let response: LoginResponse
    var requests = [URLRequest]()
    
    init(response: LoginResponse) {
        self.response = response
    }
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        requests.append(urlRequest)
        return response as! T
    }
}
