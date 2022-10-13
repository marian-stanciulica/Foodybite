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
    
    func test_createURLRequest_returnsURLRequestWithCorrectHeader() throws {
        let endpoint = EndpointStub.headers(headers: someHeaders())
        let urlRequest = try endpoint.createURLRequest()
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, someHeaders())
    }
    
    
    enum EndpointStub: Endpoint {
        case invalidPath
        case validPath
        case postMethod(method: RequestMethod)
        case headers(headers: [String : String])
        
        var host: String {
            "host"
        }
        
        var path: String {
            switch self {
            case .invalidPath:
                return "invalid path"
            default:
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
            switch self {
            case let .headers(headers):
                return headers
            default:
                return [:]
            }
        }
        
        var body: [String : String] {
            [:]
        }
        
        var urlParams: [String : String] {
            [:]
        }
    }
    
    // MARK: - Helpers
    
    private func someHeaders() -> [String : String] {
        return [
            "header 1 key" : "header 1 value",
            "header 2 key" : "header 2 value",
            "header 3 key" : "header 3 value",
        ]
    }
    
}
