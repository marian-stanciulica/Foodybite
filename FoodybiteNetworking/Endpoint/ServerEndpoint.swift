//
//  ServerEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation

enum ServerEndpoint: Endpoint {
    case signup(SignUpRequest)
    
    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        }
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Codable? {
        switch self {
        case let .signup(signUpRequest):
            return signUpRequest
        }
    }
}
