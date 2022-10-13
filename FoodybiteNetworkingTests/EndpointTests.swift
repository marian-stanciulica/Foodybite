//
//  EndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class EndpointTests: XCTestCase {

    func test_createURLRequest_returnsErrorOnInvalidURL() {
        let endpoint = EndpointStub.invalidPath
        XCTAssertThrowsError(try endpoint.createURLRequest())
    }

    enum EndpointStub: Endpoint {
        case invalidPath
        
        var host: String {
            "host"
        }
        
        var path: String {
            "invalid path"
        }
        
        var method: FoodybiteNetworking.RequestMethod {
            .post
        }
        
        var headers: [String : String] {
            [:]
        }
        
        var body: [String : String] {
            [:]
        }
        
        var urlParams: [String : String] {
            [:]
        }
    }
    
}
