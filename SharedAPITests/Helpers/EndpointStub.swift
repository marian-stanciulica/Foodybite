//
//  EndpointStub.swift
//  SharedAPITests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation
@testable import SharedAPI

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
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var method: RequestMethod {
        .get
    }
    
    var body: Codable? { nil }
}
