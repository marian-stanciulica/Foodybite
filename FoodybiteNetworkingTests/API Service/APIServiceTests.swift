//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

struct LoginResponse: Decodable {
    let name: String
    let email: String
}

protocol LoginService {
    func login(email: String, password: String) async throws -> LoginResponse
}

class APIService: LoginService {
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
    private let response: LoginResponse
    var requests = [URLRequest]()
    
    init(response: LoginResponse = LoginResponse(name: "any name", email: "any@email.com")) {
        self.response = response
    }
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        requests.append(urlRequest)
        return response as! T
    }
}

final class APIServiceTests: XCTestCase {
    
    // MARK: - LoginService Tests
    
    func test_conformsToLoginService() {
        let loader = ResourceLoaderSpy()
        let sut = APIService(loader: loader)
        XCTAssertNotNil(sut as LoginService)
    }
    
    func test_login_useLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let loginEndpoint = ServerEndpoint.login(email: email, password: password)
        let loader = ResourceLoaderSpy()
        let sut = APIService(loader: loader)
        
        _ = try await sut.login(email: email, password: password)
        
        let urlRequest = try loginEndpoint.createURLRequest()
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_login_receiveExpectedLoginResponse() async throws {
        let email = anyEmail()
        let password = anyPassword()
        let expectedResponse = LoginResponse(name: "some name", email: "some@email.com")
        
        let loader = ResourceLoaderSpy(response: expectedResponse)
        let sut = APIService(loader: loader)
        
        let receivedResponse = try await sut.login(email: email, password: password)
        
        XCTAssertEqual(expectedResponse.name, receivedResponse.name)
        XCTAssertEqual(expectedResponse.email, receivedResponse.email)
    }
    
    // MARK: - Helpers
    
    private func anyEmail() -> String {
        "test@test.com"
    }
    
    private func anyPassword() -> String {
        "123@password$321"
    }

}
