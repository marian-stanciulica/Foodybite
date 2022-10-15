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
    
    func send(_ urlRequest: URLRequest) async throws {
        let _ = try await urlSession.data(for: urlRequest, delegate: nil)
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
