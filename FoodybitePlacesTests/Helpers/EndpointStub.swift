//
//  EndpointStub.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import FoodybitePlaces

enum EndpointStub: Endpoint {
    case invalidPath
    case stub
    
    var path: String {
        switch self {
        case .invalidPath:
            return "invalid path"
        case .stub:
            return "/valid/path"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
