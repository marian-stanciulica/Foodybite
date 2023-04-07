//
//  ResourceLoaderSpy.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation
import FoodybiteNetworking

final class ResourceLoaderSpy: ResourceLoader {
    private let response: Decodable
    var requests = [URLRequest]()

    init(response: Decodable) {
        self.response = response
    }

    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        requests.append(urlRequest)
        // swiftlint:disable:next force_cast
        return response as! T
    }
}

class ResourceSenderSpy: ResourceSender {
    var requests = [URLRequest]()

    func post(to urlRequest: URLRequest) async throws {
        requests.append(urlRequest)
    }
}
