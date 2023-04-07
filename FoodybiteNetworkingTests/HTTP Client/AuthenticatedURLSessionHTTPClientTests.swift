//
//  AuthenticatedURLSessionHTTPClientTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import FoodybiteNetworking
import XCTest

final class AuthenticatedURLSessionHTTPClientTests: XCTestCase {

    func test_init_conformsToHTTPClient() {
        let (sut, _, _) = makeSUT()
        XCTAssertNotNil(sut as HTTPClient)
    }

    func test_send_performURLRequest() async throws {
        let urlRequest = anyUrlRequest()
        let (sut, httpClientSpy, tokenRefresherFake) = makeSUT()

        _ = try? await sut.send(urlRequest)

        let authRequest = try authorizeRequest(request: urlRequest, tokenRefresher: tokenRefresherFake)
        XCTAssertEqual(httpClientSpy.urlRequests, [authRequest])
    }

    func test_send_throwsErrorOnRequestError() async {
        let urlRequest = anyUrlRequest()
        let (sut, httpClientSpy, _) = makeSUT()

        let expectedError = anyError()
        httpClientSpy.result = .failure(expectedError)

        do {
            _ = try await sut.send(urlRequest)
            XCTFail("SUT should throw error on request error")
        } catch {
            XCTAssertEqual(expectedError, error as NSError)
        }
    }

    func test_send_triggersGetRemoteTokenMethodOn401StatusCodeResponse() async throws {
        let urlRequest = anyUrlRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse(code: 401)

        let (sut, httpClientSpy, tokenRefresher) = makeSUT()
        httpClientSpy.result = .success((anyData, anyHttpUrlResponse))

        _ = try await sut.send(urlRequest)

        XCTAssertEqual(tokenRefresher.getRemoteTokenCalledCount, 1)
    }

    func test_send_resendRequestAgainSignedWithNewAccessTokenAfterReceiving401StatusCode() async throws {
        let urlRequest = anyUrlRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse(code: 401)

        let (sut, httpClientSpy, tokenRefresherFake) = makeSUT()
        httpClientSpy.result = .success((anyData, anyHttpUrlResponse))

        let requestSignedWithLocalToken = try authorizeRequest(request: urlRequest, tokenRefresher: tokenRefresherFake)
        _ = try await sut.send(urlRequest)
        let requestSignedWithRemoteToken = try authorizeRequest(request: urlRequest, tokenRefresher: tokenRefresherFake)

        XCTAssertEqual(httpClientSpy.urlRequests, [requestSignedWithLocalToken, requestSignedWithRemoteToken])
    }

    func test_send_succeedsOnHTTPUrlResponseWithData() async {
        let urlRequest = anyUrlRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse()

        let (sut, httpClientSpy, _) = makeSUT()
        httpClientSpy.result = .success((anyData, anyHttpUrlResponse))

        do {
            let (receivedData, receivedResponse) = try await sut.send(urlRequest)
            XCTAssertEqual(receivedData, anyData)
            XCTAssertEqual(receivedResponse.url, anyHttpUrlResponse.url)
            XCTAssertEqual(receivedResponse.statusCode, anyHttpUrlResponse.statusCode)
        } catch {
            XCTFail("Should receive data and response, got \(error) instead")
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
