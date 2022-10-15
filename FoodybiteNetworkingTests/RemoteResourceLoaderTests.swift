//
//  RemoteResourceLoaderTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

class RemoteResourceLoader {
    private let client: HTTPClientSpy
    
    init(client: HTTPClientSpy) {
        self.client = client
    }
    
    func get(for urlRequest: URLRequest) throws {
        try client.get(for: urlRequest)
    }
}

class HTTPClientSpy {
    var urlRequests = [URLRequest]()
    var errorToThrow: NSError?
    
    func get(for urlRequest: URLRequest) throws {
        if let error = errorToThrow {
            throw error
        }
        urlRequests.append(urlRequest)
    }
}

final class RemoteResourceLoaderTests: XCTestCase {

    func test_init_noRequestTriggered() {
        let client = HTTPClientSpy()
        _ = RemoteResourceLoader(client: client)
        
        XCTAssertEqual(client.urlRequests, [])
    }
    
    func test_get_requestDataForEndpoint() throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        try sut.get(for: urlRequest)
        
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_get_requestsDataForEndpointTwice() throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        try sut.get(for: urlRequest)
        try sut.get(for: urlRequest)
        
        XCTAssertEqual(client.urlRequests, [urlRequest, urlRequest])
    }
    
    func test_get_throwErrorOnClientError() throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let client = HTTPClientSpy()
        let expectedError = NSError(domain: "any error", code: 1)
        let sut = RemoteResourceLoader(client: client)
        
        client.errorToThrow = expectedError
        
        var receivedError: NSError?
        
        do {
            try sut.get(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        XCTAssertEqual(receivedError?.domain, expectedError.domain)
        XCTAssertEqual(receivedError?.code, expectedError.code)
    }
    
    
    
}
