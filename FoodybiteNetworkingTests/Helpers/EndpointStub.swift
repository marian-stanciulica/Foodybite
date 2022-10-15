//
//  EndpointStub.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

@testable import FoodybiteNetworking

enum EndpointStub: Endpoint {
    case stub
    case invalidPath
    case validPath
    case postMethod(method: RequestMethod)
    case headers(headers: [String : String])
    case body(body: [String : String])
    
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
        switch self {
        case let .body(body):
            return body
        default:
            return [:]
        }
    }
}