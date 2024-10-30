//
//  URLSessionHTTPClientTests.swift
//  API_InfraTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
import Foundation.NSError
import API_Infra

@Suite(.serialized)
final class URLSessionHTTPClientTests {

    deinit {
        URLProtocolStub.removeStub()
    }

    @Test func send_performURLRequest() async {
        let sut = makeSUT()
        let urlRequest = anyURLRequest()
        URLProtocolStub.stub(data: nil, response: nil, error: anyError())

        _ = try? await sut.send(urlRequest)

        #expect(URLProtocolStub.capturedRequests == [urlRequest])
    }

    @Test func send_throwsErrorOnRequestError() async {
        let sut = makeSUT()
        let urlRequest = anyURLRequest()
        let expectedError = anyError()
        URLProtocolStub.stub(data: nil, response: nil, error: expectedError)

        do {
            let result = try await sut.send(urlRequest)
            Issue.record("Expected to throw error on request error, got \(result) instead")
        } catch let error as NSError {
            #expect(expectedError.domain == error.domain)
            #expect(expectedError.code == error.code)
        }
    }

    @Test func send_throwErrorOnInvalidCases() async {
        let sut = makeSUT()
        let urlRequest = anyURLRequest()
        URLProtocolStub.stub(data: anyData(), response: anyUrlResponse(), error: nil)

        do {
            let result = try await sut.send(urlRequest)
            Issue.record("Expected to throw error when response is URLResponse, got \(result) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func send_succeedsOnHTTPUrlResponseWithData() async {
        let sut = makeSUT()
        let urlRequest = anyURLRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse()
        URLProtocolStub.stub(data: anyData, response: anyHttpUrlResponse, error: nil)

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

    private func makeSUT() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        return sut
    }

    private func anyURLRequest() -> URLRequest {
        URLRequest(url: URL(string: "http://any-url.com")!)
    }

    private func anyUrlResponse() -> URLResponse {
        URLResponse(url: URL(string: "http://any-url.com")!,
                    mimeType: nil,
                    expectedContentLength: 0,
                    textEncodingName: nil)
    }

    private func anyHttpUrlResponse(code: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                        statusCode: code,
                        httpVersion: nil,
                        headerFields: nil)!
    }

    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }

    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }

}
