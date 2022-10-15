//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

struct LoginResponse: Decodable {
    
}

class APIService {
    private let loader: ResourceLoader
    
    init(loader: ResourceLoader) {
        self.loader = loader
    }
    
    func login() async throws -> LoginResponse {
        return try await loader.get(for: URLRequest(url: URL(string: "http://any-url.com")!))
    }
}

class ResourceLoaderSpy: ResourceLoader {
    var requestsCount = 0
    
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        requestsCount += 1
        return LoginResponse() as! T
    }
    
}

final class APIServiceTests: XCTestCase {

    func test_login_sendsURLRequstToRemoteLoader() async throws {
        let loader = ResourceLoaderSpy()
        let sut = APIService(loader: loader)
        
        _ = try await sut.login()
        
        XCTAssertEqual(loader.requestsCount, 1)
    }
    

}
