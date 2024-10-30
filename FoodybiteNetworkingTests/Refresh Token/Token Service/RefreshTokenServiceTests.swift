//
//  RefreshTokenServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Testing
import Foundation.NSURLRequest
@testable import FoodybiteNetworking

struct RefreshTokenServiceTests {

    @Test func conformsToTokenRefresher() {
        let (sut, _, _) = makeSUT()
        #expect(sut as TokenRefresher != nil)
    }

    @Test func getLocalToken_returnsAuthTokenFromTokenStore() throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        let receivedToken = try tokenStoreStub.read()
        let expectedToken = try sut.getLocalToken()

        #expect(expectedToken.accessToken == receivedToken.accessToken)
        #expect(expectedToken.refreshToken == receivedToken.refreshToken)
    }

    @Test func fetchLocallyRemoteToken_usesRefreshTokenEndpointToCreateURLRequest() async throws {
        let (sut, loaderSpy, tokenStoreStub) = makeSUT()
        let authToken = try tokenStoreStub.read()

        try await sut.fetchLocallyRemoteToken()

        #expect(loaderSpy.requests.count == 1)
        assertURLComponents(
            urlRequest: loaderSpy.requests[0],
            path: "/auth/accessToken",
            method: .post,
            body: RefreshTokenRequestBody(refreshToken: authToken.refreshToken))
    }

    @Test func fetchLocallyRemoteToken_makesRefreshTokenRequestOnlyOnceWhenCalledMultipleTimesInParallel() async throws {
        let (sut, loaderSpy, _) = makeSUT(authToken: makeRemoteAuthToken())

        await requestRemoteAuthTokenInParallel(on: sut, numberOfRequests: 10)

        #expect(loaderSpy.requests.count == 1)
    }

    @Test func fetchLocallyRemoteToken_receiveExpectedAuthTokenResponse() async throws {
        let expectedAuthToken = makeRemoteAuthToken()
        let (sut, _, _) = makeSUT(authToken: expectedAuthToken)

        try await sut.fetchLocallyRemoteToken()
        let receivedResponse = try sut.getLocalToken()

        #expect(expectedAuthToken.accessToken == receivedResponse.accessToken)
        #expect(expectedAuthToken.refreshToken == receivedResponse.refreshToken)
    }

    @Test func fetchLocallyRemoteToken_storesAuthTokenInTokenStore() async throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        try await sut.fetchLocallyRemoteToken()
        let expectedToken = try sut.getLocalToken()
        let receivedToken = try tokenStoreStub.read()

        #expect(expectedToken.accessToken == receivedToken.accessToken)
        #expect(expectedToken.refreshToken == receivedToken.refreshToken)
    }

    @Test func fetchLocallyRemoteToken_storesAuthTokenOnlyOnceWhenCalledMultipleTimesInParallel() async throws {
        let (sut, _, tokenStoreStub) = makeSUT()

        await requestRemoteAuthTokenInParallel(on: sut, numberOfRequests: 10)

        #expect(tokenStoreStub.writeCount == 1)
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
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)

        #expect(urlComponents?.scheme == "http", sourceLocation: sourceLocation)
        #expect(urlComponents?.port == 8080, sourceLocation: sourceLocation)
        #expect(urlComponents?.host == "localhost", sourceLocation: sourceLocation)
        #expect(urlComponents?.path == path, sourceLocation: sourceLocation)
        #expect(urlComponents?.queryItems == nil, sourceLocation: sourceLocation)
        #expect(urlRequest.httpMethod == method.rawValue, sourceLocation: sourceLocation)

        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601

            if let bodyData = try? encoder.encode(body) {
                #expect(urlRequest.httpBody == bodyData, "HTTP Body is not correct", sourceLocation: sourceLocation)
            } else {
                Issue.record("Couldn't encode the body", sourceLocation: sourceLocation)
            }
        } else if let httpBody = urlRequest.httpBody {
            Issue.record("Body expected to be nil, got \(httpBody) instead")
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
