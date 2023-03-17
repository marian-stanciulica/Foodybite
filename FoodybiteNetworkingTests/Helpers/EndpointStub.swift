//
//  EndpointStub.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation
import SharedAPI

enum EndpointStub: Endpoint {
    case stub
    
    var scheme: String {
        "http"
    }
    
    var port: Int? {
        nil
    }
    
    var host: String {
        "host"
    }
    
    var path: String {
        return "/path"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var body: Encodable? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
