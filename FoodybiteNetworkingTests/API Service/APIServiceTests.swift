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
    
    init(response: LoginResponse) {
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
        let (sut, _) = makeSUT()
        XCTAssertNotNil(sut as LoginService)
    }
    
    func test_login_useLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let (sut, loader) = makeSUT()
        let loginEndpoint = ServerEndpoint.login(email: email, password: password)
        let urlRequest = try loginEndpoint.createURLRequest()
        
        _ = try await sut.login(email: email, password: password)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_login_receiveExpectedLoginResponse() async throws {
        let expectedResponse = LoginResponse(name: "some name", email: "some@email.com")
        let sut = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.login(email: anyEmail(), password: anyPassword())
        
        XCTAssertEqual(expectedResponse.name, receivedResponse.name)
        XCTAssertEqual(expectedResponse.email, receivedResponse.email)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: APIService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: LoginResponse(name: "", email: ""))
        let sut = APIService(loader: loader)
        return (sut, loader)
    }
    
    private func makeSUT(response: LoginResponse = LoginResponse(name: "any name", email: "any@email.com")) -> APIService {
        let loader = ResourceLoaderSpy(response: response)
        return APIService(loader: loader)
    }
    
    private func anyEmail() -> String {
        "test@test.com"
    }
    
    private func anyPassword() -> String {
        "123@password$321"
    }

}
