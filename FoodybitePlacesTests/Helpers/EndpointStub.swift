//
//  EndpointStub.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
@testable import FoodybitePlaces

enum EndpointStub: Endpoint {
    case stub
    
    var host: String {
        "host"
    }
    
    var path: String {
        "/stub"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var body: Codable? {
        nil
    }
}
