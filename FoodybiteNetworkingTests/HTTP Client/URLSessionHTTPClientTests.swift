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
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        requests.append(request)
        throw NSError(domain: "any error", code: 1)
    }
    
    
}
