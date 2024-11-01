//
//  HTTPClientSpy.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import FoodybitePlaces

final class HTTPClientSpy: HTTPClient {
    var urlRequests = [URLRequest]()
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

        return (anyLoginMocksData(), anyHttpUrlResponse())
    }

    private func anyLoginMocksData() -> Data {
        let loginMocks = [
            CodableMock(name: "name 1", password: "password 1"),
            CodableMock(name: "name 2", password: "password 2")
        ]
        return (try? JSONEncoder().encode(loginMocks)) ?? Data()
    }
}
