//
//  RefreshTokenServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

@testable import FoodybiteNetworking
import XCTest

final class RefreshTokenServiceTests: XCTestCase {

    func test_conformsToTokenRefresher() {
        let (sut, _, _) = makeSUT()
        XCTAssertNotNil(sut as TokenRefresher)
    }

    func test_fetchLocallyRemoteToken_returnsAuthTokenFromTokenStore() throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        let receivedToken = try tokenStoreStub.read()
        let expectedToken = try sut.getLocalToken()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }
    
    func test_fetchLocallyRemoteToken_refreshTokenFromStoreUsedToCreateEndpoint() async throws {
        let (sut, loaderSpy, tokenStoreStub) = makeSUT()
        let authToken = try tokenStoreStub.read()
        let refreshTokenEndpoint = ServerEndpoint.refreshToken(authToken.refreshToken)
        let urlRequest = try refreshTokenEndpoint.createURLRequest()

        try await sut.fetchLocallyRemoteToken()

        let firstRequest = loaderSpy.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_fetchLocallyRemoteToken_useRefreshTokenEndpointToCreateURLRequest() async throws {
        let (sut, loaderSpy, tokenStoreStub) = makeSUT()
        let authToken = try tokenStoreStub.read()
        let refreshTokenEndpoint = ServerEndpoint.refreshToken(authToken.refreshToken)
        let urlRequest = try refreshTokenEndpoint.createURLRequest()

        try await sut.fetchLocallyRemoteToken()

        XCTAssertEqual(loaderSpy.requests, [urlRequest])
    }

    func test_fetchLocallyRemoteToken_receiveExpectedAuthTokenResponse() async throws {
        let expectedAccessToken = "expected access token"
        let expectedRefreshToken = "expected refresh token"
        let (sut, _, _) = makeSUT(accessToken: expectedAccessToken, refreshToken: expectedRefreshToken)

        try await sut.fetchLocallyRemoteToken()
        let receivedResponse = try sut.getLocalToken()

        XCTAssertEqual(expectedAccessToken, receivedResponse.accessToken)
        XCTAssertEqual(expectedRefreshToken, receivedResponse.refreshToken)
    }
    
    func test_fetchLocallyRemoteToken_storesAuthTokenInTokenStore() async throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        try await sut.fetchLocallyRemoteToken()
        let expectedToken = try sut.getLocalToken()
        let receivedToken = try tokenStoreStub.read()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }

    // MARK: - Helpers

    private func makeSUT(accessToken: String = "remote access token",
                         refreshToken: String = "remote refresh token") -> (sut: RefreshTokenService,
                                                                   loader: TokenRefreshLoaderSpy,
                                                                   tokenStore: TokenStoreStub) {
        let loaderSpy = TokenRefreshLoaderSpy(response: AuthToken(accessToken: accessToken, refreshToken: refreshToken))
        let tokenStoreStub = TokenStoreStub(AuthToken(accessToken: "stored access token", refreshToken: "stored refresh token"))
        let sut = RefreshTokenService(loader: loaderSpy, tokenStore: tokenStoreStub)
        return (sut, loaderSpy, tokenStoreStub)
    }
    
    private func randomString(size: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        return String(Array(0..<size).map { _ in chars.randomElement()! })
    }

}
