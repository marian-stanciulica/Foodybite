//
//  EndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybitePlaces

final class EndpointTests: XCTestCase {

    func test_createURLRequest_throwErrorOnInvalidURL() {
        let endpoint = EndpointStub.invalidPath
        XCTAssertThrowsError(try endpoint.createURLRequest())
    }
    
    func test_createURLRequest_returnsURLRequestWithValidURL() throws {
        let endpoint = EndpointStub.stub
        let expectedURLString = "https://" + endpoint.host + endpoint.path
        
        let urlRequest = try endpoint.createURLRequest()
        
        XCTAssertEqual(urlRequest.url?.absoluteString, expectedURLString)
    }
    
}
