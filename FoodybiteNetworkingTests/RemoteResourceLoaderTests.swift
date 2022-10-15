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
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClientSpy) {
        self.client = client
    }
    
    func get(for urlRequest: URLRequest) throws {
        let response: HTTPURLResponse
        
        do {
            (_, response) = try client.get(for: urlRequest)
        } catch {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw Error.invalidData
        }
    }
}

class HTTPClientSpy {
    var urlRequests = [URLRequest]()
    var errorToThrow: NSError?
    var successResult: (data: Data, response: HTTPURLResponse)?
    
    private let defaultResponse = (
        "any data".data(using: .utf8)!,
        HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil)!
    )
    
    func get(for urlRequest: URLRequest) throws -> (Data, HTTPURLResponse) {
        urlRequests.append(urlRequest)
        
        if let successResult = successResult {
            return successResult
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        return defaultResponse
    }
}

final class RemoteResourceLoaderTests: XCTestCase {

    func test_init_noRequestTriggered() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.urlRequests, [])
    }
    
    func test_get_requestDataForEndpoint() throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        try sut.get(for: urlRequest)
        
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_get_requestsDataForEndpointTwice() throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        try sut.get(for: urlRequest)
        try sut.get(for: urlRequest)
        
        XCTAssertEqual(client.urlRequests, [urlRequest, urlRequest])
    }
    
    func test_get_throwErrorOnClientError() throws {
        let (sut, client) = makeSUT()
        let urlRequest = try EndpointStub.stub.createURLRequest()
        
        client.errorToThrow = NSError(domain: "any error", code: 1)
        
        var receivedError: NSError?
        do {
            try sut.get(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        XCTAssertEqual(receivedError, RemoteResourceLoader.Error.connectivity as NSError)
    }
    
    func test_get_throwErrorOnNon2xxStatusCodeResponse() throws {
        let (sut, client) = makeSUT()
        let urlRequest = try EndpointStub.stub.createURLRequest()
        
        let anyData = "any data".data(using: .utf8)!
        let response = HTTPURLResponse(url: urlRequest.url!, statusCode: 300, httpVersion: nil, headerFields: nil)!
        client.successResult = (data: anyData, response: response)
        
        var receivedError: NSError?
        do {
            try sut.get(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        XCTAssertEqual(receivedError, RemoteResourceLoader.Error.invalidData as NSError)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        return (sut, client)
    }
    
    
    
}
