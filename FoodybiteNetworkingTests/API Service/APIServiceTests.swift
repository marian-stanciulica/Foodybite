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
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = ServerEndpoint.login(email: email, password: password)
        let urlRequest = try endpoint.createURLRequest()
        return try await loader.get(for: urlRequest)
    }
}

class ResourceLoaderSpy: ResourceLoader {
    var requests = [URLRequest]()
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        requests.append(urlRequest)
        return LoginResponse() as! T
    }
    
}

final class APIServiceTests: XCTestCase {
    
    func test_login_useLoginEndpointToCreateURLRequest() async throws {
        let loginEndpoint = ServerEndpoint.login(email: "test@test.com", password: "123@password$321")
        let loader = ResourceLoaderSpy()
        let sut = APIService(loader: loader)
        
        _ = try await sut.login(email: "test@test.com", password: "123@password$321")
        
        let urlRequest = try loginEndpoint.createURLRequest()
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    

}
