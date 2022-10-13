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
    
    func test_createURLRequest_returnsValidURL() throws {
        let endpoint = EndpointStub.validPath
        let expectedURLString = "http://" + endpoint.host + ":8080" + endpoint.path
        
        let urlRequest = try endpoint.createURLRequest()
        
        XCTAssertEqual(urlRequest.url?.absoluteString, expectedURLString)
    }

    enum EndpointStub: Endpoint {
        case invalidPath
        case validPath
        
        var host: String {
            "host"
        }
        
        var path: String {
            switch self {
            case .invalidPath:
                return "invalid path"
            case .validPath:
                return "/auth/login"
            }
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
