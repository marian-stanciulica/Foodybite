//
//  AuthenticatedURLSessionHTTPClientTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import FoodybiteNetworking
import Testing
import Foundation.NSURLRequest

struct AuthenticatedURLSessionHTTPClientTests {

    @Test func init_conformsToHTTPClient() {
        let (sut, _, _) = makeSUT()
        #expect(sut as HTTPClient != nil)
    }

    @Test func send_performURLRequest() async throws {
        let urlRequest = anyUrlRequest()
        let (sut, httpClientSpy, tokenRefresherFake) = makeSUT()

        _ = try? await sut.send(urlRequest)

        let authRequest = try authorizeRequest(request: urlRequest, tokenRefresher: tokenRefresherFake)
        #expect(httpClientSpy.urlRequests == [authRequest])
    }

    @Test func send_throwsErrorOnRequestError() async {
        let urlRequest = anyUrlRequest()
        let (sut, httpClientSpy, _) = makeSUT()

        let expectedError = anyError()
        httpClientSpy.result = .failure(expectedError)

        do {
            _ = try await sut.send(urlRequest)
            Issue.record("SUT should throw error on request error")
        } catch {
            #expect(expectedError == error as NSError)
        }
    }

    @Test func send_triggersGetRemoteTokenMethodOn401StatusCodeResponse() async throws {
        let urlRequest = anyUrlRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse(code: 401)

        let (sut, httpClientSpy, tokenRefresher) = makeSUT()
        httpClientSpy.result = .success((anyData, anyHttpUrlResponse))

        _ = try await sut.send(urlRequest)

        #expect(tokenRefresher.getRemoteTokenCalledCount == 1)
    }

    @Test func send_resendRequestAgainSignedWithNewAccessTokenAfterReceiving401StatusCode() async throws {
        let urlRequest = anyUrlRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse(code: 401)

        let (sut, httpClientSpy, tokenRefresherFake) = makeSUT()
        httpClientSpy.result = .success((anyData, anyHttpUrlResponse))

        let requestSignedWithLocalToken = try authorizeRequest(request: urlRequest, tokenRefresher: tokenRefresherFake)
        _ = try await sut.send(urlRequest)
        let requestSignedWithRemoteToken = try authorizeRequest(request: urlRequest, tokenRefresher: tokenRefresherFake)

        #expect(httpClientSpy.urlRequests == [requestSignedWithLocalToken, requestSignedWithRemoteToken])
    }

    @Test func send_succeedsOnHTTPUrlResponseWithData() async {
        let urlRequest = anyUrlRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse()

        let (sut, httpClientSpy, _) = makeSUT()
        httpClientSpy.result = .success((anyData, anyHttpUrlResponse))

        do {
            let (receivedData, receivedResponse) = try await sut.send(urlRequest)
            #expect(receivedData == anyData)
            #expect(receivedResponse.url == anyHttpUrlResponse.url)
            #expect(receivedResponse.statusCode == anyHttpUrlResponse.statusCode)
        } catch {
            Issue.record("Should receive data and response, got \(error) instead")
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HTTPClient, httClientSpy: HTTPClientSpy, tokenRefresherFake: TokenRefresherFake) {
        let httpClientSpy = HTTPClientSpy()
        let tokenRefresherFake = TokenRefresherFake()
        let sut = AuthenticatedURLSessionHTTPClient(decoratee: httpClientSpy, tokenRefresher: tokenRefresherFake)
        return (sut, httpClientSpy, tokenRefresherFake)
    }

    private func authorizeRequest(request: URLRequest, tokenRefresher: TokenRefresher) throws -> URLRequest {
        let authToken = try tokenRefresher.getLocalToken()

        var request = request
        request.setValue("Bearer \(authToken.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
