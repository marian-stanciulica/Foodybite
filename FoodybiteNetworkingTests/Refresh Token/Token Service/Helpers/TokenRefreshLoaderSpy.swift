//
//  TokenRefreshLoaderSpy.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Foundation
import FoodybiteNetworking

final class TokenRefreshLoaderSpy: ResourceLoader {
    private let response: AuthToken
    var requests = [URLRequest]()

    init(response: AuthToken) {
        self.response = response
    }

    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        requests.append(urlRequest)
        // swiftlint:disable:next force_cast
        return response as! T
    }
}
