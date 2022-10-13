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
    
    
    enum EndpointStub: Endpoint {
        case invalidPath
        case validPath
        case postMethod(method: RequestMethod)
        
        var host: String {
            "host"
        }
        
        var path: String {
            switch self {
            case .invalidPath:
                return "invalid path"
            case .validPath, .postMethod:
                return "/auth/login"
            }
        }
        
        var method: FoodybiteNetworking.RequestMethod {
            switch self {
            case let .postMethod(method):
                return method
            default:
                return .get
            }
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
