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
    
    func get(for urlRequest: URLRequest) {
        client.get(for: urlRequest)
    }
}

class HTTPClientSpy {
    var urlRequests = [URLRequest]()
    
    func get(for urlRequest: URLRequest) {
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
        
        sut.get(for: urlRequest)
        
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_get_requestsDataForEndpointTwice() throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        sut.get(for: urlRequest)
        sut.get(for: urlRequest)
        
        XCTAssertEqual(client.urlRequests, [urlRequest, urlRequest])
    }
    
    
    
}
