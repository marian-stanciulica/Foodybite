//
//  RefreshTokenServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class RefreshTokenServiceTests: XCTestCase {

    func test_conformsToTokenRefresher() {
        let (sut, _, _) = makeSUT()
        XCTAssertNotNil(sut as TokenRefresher)
    }

    func test_getLocalToken_returnsAuthTokenFromTokenStore() throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        let receivedToken = try tokenStoreStub.read()
        let expectedToken = try sut.getLocalToken()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }
    
    func test_fetchLocallyRemoteToken_usesRefreshTokenEndpointToCreateURLRequest() async throws {
        let (sut, loaderSpy, tokenStoreStub) = makeSUT()
        let authToken = try tokenStoreStub.read()

        try await sut.fetchLocallyRemoteToken()

        XCTAssertEqual(loaderSpy.requests.count, 1)
        assertURLComponents(
            urlRequest: loaderSpy.requests[0],
            path: "/auth/accessToken",
            method: .post,
            body: RefreshTokenRequestBody(refreshToken: authToken.refreshToken))
    }

    func test_fetchLocallyRemoteToken_makesRefreshTokenRequestOnlyOnceWhenCalledMultipleTimesInParallel() async throws {
        let (sut, loaderSpy, _) = makeSUT(authToken: makeRemoteAuthToken())
        
        await requestRemoteAuthTokenInParallel(on: sut, numberOfRequests: 10)
        
        XCTAssertEqual(loaderSpy.requests.count, 1)
    }
    
    func test_fetchLocallyRemoteToken_receiveExpectedAuthTokenResponse() async throws {
        let expectedAuthToken = makeRemoteAuthToken()
        let (sut, _, _) = makeSUT(authToken: expectedAuthToken)

        try await sut.fetchLocallyRemoteToken()
        let receivedResponse = try sut.getLocalToken()

        XCTAssertEqual(expectedAuthToken.accessToken, receivedResponse.accessToken)
        XCTAssertEqual(expectedAuthToken.refreshToken, receivedResponse.refreshToken)
    }
    
    func test_fetchLocallyRemoteToken_storesAuthTokenInTokenStore() async throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        try await sut.fetchLocallyRemoteToken()
        let expectedToken = try sut.getLocalToken()
        let receivedToken = try tokenStoreStub.read()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }
    
    func test_fetchLocallyRemoteToken_storesAuthTokenOnlyOnceWhenCalledMultipleTimesInParallel() async throws {
        let (sut, _, tokenStoreStub) = makeSUT()
        
        await requestRemoteAuthTokenInParallel(on: sut, numberOfRequests: 10)
        
        XCTAssertEqual(tokenStoreStub.writeCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(authToken: AuthToken? = nil) -> (sut: TokenRefresher,
                                                          loader: TokenRefreshLoaderSpy,
                                                          tokenStore: TokenStoreStub) {
        let defaultAuthToken = makeRemoteAuthToken()
        let loaderSpy = TokenRefreshLoaderSpy(response: authToken ?? defaultAuthToken)
        let tokenStoreStub = TokenStoreStub(makeRemoteAuthToken())
        let sut = RefreshTokenService(loader: loaderSpy, tokenStore: tokenStoreStub)
        return (sut, loaderSpy, tokenStoreStub)
    }
    
    private func assertURLComponents(
        urlRequest: URLRequest,
        path: String,
        method: FoodybiteNetworking.RequestMethod,
        body: Encodable? = nil,
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
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let bodyData = try! encoder.encode(body)
            XCTAssertEqual(urlRequest.httpBody, bodyData, file: file, line: line)
        } else if let httpBody = urlRequest.httpBody {
            XCTFail("Body expected to be nil, got \(httpBody) instead")
        }
    }
    
    private func requestRemoteAuthTokenInParallel(on sut: TokenRefresher, numberOfRequests: Int) async {
        await withThrowingTaskGroup(of: Void.self) { group in
            (0..<numberOfRequests).forEach { _ in
                group.addTask {
                    try await sut.fetchLocallyRemoteToken()
                }
            }
        }
    }
    
    private func makeRemoteAuthToken() -> AuthToken {
        AuthToken(accessToken: "remote access token", refreshToken: "remote refresh token")
    }
    
    private func makeStoredAuthToken() -> AuthToken {
        AuthToken(accessToken: "stored access token", refreshToken: "stored refresh token")
    }

}
