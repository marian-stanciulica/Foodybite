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

    func test_getLocalToken_returnsAuthTokenFromTokenStore() throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        let receivedToken = try tokenStoreStub.read()
        let expectedToken = try sut.getLocalToken()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }
    
    func test_getRemoteToken_refreshTokenFromStoreUsedToCreateEndpoint() async throws {
        let (sut, loaderSpy, tokenStoreStub) = makeSUT()
        let authToken = try tokenStoreStub.read()
        let refreshTokenEndpoint = ServerEndpoint.refreshToken(authToken.refreshToken)
        let urlRequest = try refreshTokenEndpoint.createURLRequest()

        _ = try await sut.getRemoteToken()

        let firstRequest = loaderSpy.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_getRemoteToken_useRefreshTokenEndpointToCreateURLRequest() async throws {
        let (sut, loaderSpy, tokenStoreStub) = makeSUT()
        let authToken = try tokenStoreStub.read()
        let refreshTokenEndpoint = ServerEndpoint.refreshToken(authToken.refreshToken)
        let urlRequest = try refreshTokenEndpoint.createURLRequest()

        _ = try await sut.getRemoteToken()

        XCTAssertEqual(loaderSpy.requests, [urlRequest])
    }

    func test_getRemoteToken_receiveExpectedAuthTokenResponse() async throws {
        let expectedAccessToken = "expected access token"
        let expectedRefreshToken = "expected refresh token"
        let (sut, _, _) = makeSUT(accessToken: expectedAccessToken, refreshToken: expectedRefreshToken)

        let receivedResponse = try await sut.getRemoteToken()

        XCTAssertEqual(expectedAccessToken, receivedResponse.accessToken)
        XCTAssertEqual(expectedRefreshToken, receivedResponse.refreshToken)
    }
    
    func test_getRemoteToken_storesAuthTokenInTokenStore() async throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        let expectedToken = try await sut.getRemoteToken()
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
