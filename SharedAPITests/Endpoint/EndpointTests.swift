//
//  EndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import SharedAPI

final class EndpointTests: XCTestCase {

    func test_createURLRequest_throwErrorOnInvalidURL() {
        let endpoint = EndpointStub.invalidPath
        XCTAssertThrowsError(try endpoint.createURLRequest())
    }
    
    func test_createURLRequest_returnsURLRequestWithValidURL() throws {
        let endpoint = EndpointStub.validPath
        let expectedURLString = "https://" + endpoint.host + endpoint.path
        
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
        let endpoint = EndpointStub.headers(headers: makeHeaders())
        let urlRequest = try endpoint.createURLRequest()
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, makeHeaders())
    }
    
    func test_createURLRequest_returnsURLRequestWithCorrectBody() throws {
        let endpoint = EndpointStub.body(body: anyBody())
        let urlRequest = try endpoint.createURLRequest()
        
        let receivedBodyData = try XCTUnwrap(urlRequest.httpBody)
        let decoder = JSONDecoder()
        let receivedBody = try decoder.decode(String.self, from: receivedBodyData)
        
        XCTAssertEqual(receivedBody, anyBody())
    }
    
    // MARK: - Helpers

    private func makeHeaders() -> [String : String] {
        ["Content-Type": "application/json"]
    }

    private func anyBody() -> String {
        "any body"
    }
    
}
