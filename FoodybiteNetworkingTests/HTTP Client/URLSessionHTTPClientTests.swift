//
//  URLSessionHTTPClientTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

class URLSessionHTTPClient {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    struct UnexpectedValuesRepresentation: Error {}
    
    func send(_ urlRequest: URLRequest) async throws {
        let (_, response) = try await urlSession.data(for: urlRequest, delegate: nil)
        
        if let _ = response as? HTTPURLResponse {
            
        } else {
            throw UnexpectedValuesRepresentation()
        }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_send_performURLRequest() async throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(urlSession: session)
        
        try? await sut.send(urlRequest)
        
        XCTAssertEqual(session.requests, [urlRequest])
    }
    
    func test_send_throwsErrorOnRequestError() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let expectedError = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy(result: .failure(expectedError))
        let sut = URLSessionHTTPClient(urlSession: session)
        
        do {
            try await sut.send(urlRequest)
            XCTFail("SUT should throw error on request error")
        } catch {
            XCTAssertEqual(expectedError, error as NSError)
        }
    }
    
    func test_send_throwErrorOnInvalidCases() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let session = URLSessionSpy(result: .success((Data(), URLResponse(url: URL(string: "http://any-url.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))))
        let sut = URLSessionHTTPClient(urlSession: session)
        
        do {
            try await sut.send(urlRequest)
            XCTFail("SUT should throw error if response is URLResponse")
        } catch {}
    }

}

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class URLSessionSpy: URLSessionProtocol {
    private(set) var requests = [URLRequest]()
    private let result: Result<(Data, URLResponse), Error>
    
    init(result: Result<(Data, URLResponse), Error> = .success((anyData(), anyValidResponse()))) {
        self.result = result
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        requests.append(request)
        return try result.get()
    }
    
    private static func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private static func anyValidResponse() -> URLResponse {
        HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil)!
    }
    
}
