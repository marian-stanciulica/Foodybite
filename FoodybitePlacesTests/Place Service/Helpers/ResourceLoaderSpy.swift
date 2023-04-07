//
//  ResourceLoaderSpy.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import FoodybitePlaces

final class ResourceLoaderSpy: ResourceLoader, DataLoader {
    private let response: Decodable
    var data: Data?
    var getRequests = [URLRequest]()
    var getDataRequests = [URLRequest]()

    init(response: Decodable) {
        self.response = response
    }

    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        getRequests.append(urlRequest)
        // swiftlint:disable:next force_cast
        return response as! T
    }

    func getData(for urlRequest: URLRequest) async throws -> Data {
        getDataRequests.append(urlRequest)
        return data ?? Data()
    }
}
