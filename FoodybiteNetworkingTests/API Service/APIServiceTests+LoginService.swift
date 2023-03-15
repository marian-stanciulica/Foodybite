//
//  APIServiceTests+LoginService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain
import SharedAPI

extension APIServiceTests {
    
    func test_conformsToLoginService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LoginService)
    }
    
    func test_login_usesLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let (sut, loader, _, _) = makeSUT(response: anyLoginResponse().response)
        let body = LoginRequest(email: email, password: password)
        
        _ = try await sut.login(email: email, password: password)
        
        XCTAssertEqual(loader.requests.count, 1)
        assertURLComponents(
            urlRequest: loader.requests[0],
            path: "/auth/login",
            method: .post,
            body: body)
    }
    
    func test_login_receiveExpectedLoginResponse() async throws {
        let (response, expectedModel) = anyLoginResponse()
        let (sut, _, _, _) = makeSUT(response: response)
        
        let receivedResponse = try await sut.login(email: anyEmail(), password: anyPassword())
        
        XCTAssertEqual(expectedModel, receivedResponse)
    }
    
    func test_login_storesAuthTokenInKeychain() async throws {
        let (sut, _, _, tokenStoreStub) = makeSUT(response: anyLoginResponse().response)
        
        _ = try await sut.login(email: anyEmail(), password: anyPassword())
        let receivedToken = try tokenStoreStub.read()
        
        XCTAssertEqual(receivedToken, anyAuthToken())
    }
    
    // MARK: - Helpers
    
    private func assertURLComponents(
        urlRequest: URLRequest,
        path: String,
        method: RequestMethod,
        body: Encodable,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)

        XCTAssertEqual(urlComponents?.scheme, "http", file: file, line: line)
        XCTAssertEqual(urlComponents?.port, 8080, file: file, line: line)
        XCTAssertEqual(urlComponents?.host, "localhost", file: file, line: line)
        XCTAssertEqual(urlComponents?.path, path, file: file, line: line)
        XCTAssertNil(urlComponents?.queryItems, file: file, line: line)
        XCTAssertEqual(urlRequest.httpMethod, method.rawValue, file: file, line: line)
        
        let encoder = JSONEncoder()
        let bodyData = try! encoder.encode(body)
        XCTAssertEqual(urlRequest.httpBody, bodyData, file: file, line: line)
    }
    
    private func anyLoginResponse() -> (response: LoginResponse, model: User) {
        let id = UUID()
        let response = LoginResponse(
            user: RemoteUser(id: id,
                             name: "any name",
                             email: "any@email.com",
                             profileImage: nil),
            token: anyAuthToken()
        )
        
        let model = User(id: id, name: "any name", email: "any@email.com", profileImage: nil)
        return (response, model)
    }
    
    private func anyAuthToken() -> AuthToken {
        AuthToken(accessToken: "any access token",
                         refreshToken: "any refresh token")
    }
}
