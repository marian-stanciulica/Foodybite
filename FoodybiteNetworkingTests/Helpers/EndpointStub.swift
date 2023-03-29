//
//  EndpointStub.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation
@testable import FoodybiteNetworking

enum EndpointStub: Endpoint {
    case stub
    
    var path: String {
        return "/path"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var body: Encodable? {
        nil
    }
}
