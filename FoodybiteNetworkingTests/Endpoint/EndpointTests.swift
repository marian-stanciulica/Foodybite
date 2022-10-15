//
//  EndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class EndpointTests: XCTestCase {

    func test_createURLRequest_throwErrorOnInvalidURL() {
        let endpoint = EndpointStub.invalidPath
        XCTAssertThrowsError(try endpoint.createURLRequest())
    }
    
    func test_createURLRequest_returnsURLRequestWithValidURL() throws {
        let endpoint = EndpointStub.validPath
        let expectedURLString = "http://" + endpoint.host + ":8080" + endpoint.path
        
        let urlRequest = try endpoint.createURLRequest()
        
        XCTAssertEqual(urlRequest.url?.absoluteString, expectedURLString)
    }
    
    func test_createURLRequest_returnsURLRequestWithCorrectRequestMethod() throws {
        let allMethods: [RequestMethod] = [.delete, .get, .post, .patch, .put]
        
        try allMethods.forEach { method in
            let endpoint = EndpointStub.postMethod(method: method)
            let urlRequest = try endpoint.createURLRequest()
            
            XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
        }
    }
    
    func test_createURLRequest_returnsURLRequestWithCorrectHeaders() throws {
        let endpoint = EndpointStub.headers(headers: someHeaders())
        let urlRequest = try endpoint.createURLRequest()
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, someHeaders())
    }
    
    func test_createURLRequest_returnsURLRequestWithCorrectBody() throws {
        let endpoint = EndpointStub.body(body: anyBody())
        let urlRequest = try endpoint.createURLRequest()
        
        let receivedBodyData = try XCTUnwrap(urlRequest.httpBody)
        let receivedBody = try JSONSerialization.jsonObject(with: receivedBodyData) as? [String : String]
        
        XCTAssertEqual(receivedBody, anyBody())
    }
    
    // MARK: - Helpers

    private func someHeaders() -> [String : String] {
        return [
            "header 1 key" : "header 1 value",
            "header 2 key" : "header 2 value",
            "header 3 key" : "header 3 value",
        ]
    }

    private func anyBody() -> [String : String] {
        return [
            "body 1 key" : "body 1 value",
            "body 2 key" : "body 2 value"
        ]
    }
    
}