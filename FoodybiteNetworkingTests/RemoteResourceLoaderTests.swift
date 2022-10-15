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
    
    var result: Result<(Data, HTTPURLResponse), NSError>?
    
    private let defaultResponse = (
        "any data".data(using: .utf8)!,
        HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil)!
    )
    
    func get(for urlRequest: URLRequest) throws -> (Data, HTTPURLResponse) {
        urlRequests.append(urlRequest)
        
        if let result = result {
            switch result {
            case let .failure(error):
                throw error
            case let .success(result):
                return result
            }
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
        try expect(forClientResult: .failure(NSError(domain: "any error", code: 1)),
                   expected: .connectivity)
    }
    
    func test_get_throwErrorOnNon2xxStatusCodeResponse() throws {
        let anyData = "any data".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                                       statusCode: 300,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        try expect(forClientResult: .success((data: anyData, response: response)),
                   expected: .invalidData)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        return (sut, client)
    }
    
    private func expect(forClientResult result: Result<(Data, HTTPURLResponse), NSError>, expected: RemoteResourceLoader.Error, file: StaticString = #filePath, line: UInt = #line) throws {
        let (sut, client) = makeSUT()
        let urlRequest = try EndpointStub.stub.createURLRequest()
        client.result = result
        
        var receivedError: NSError?
        do {
            try sut.get(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        XCTAssertEqual(receivedError, expected as NSError, file: file, line: line)
    }
    
}
