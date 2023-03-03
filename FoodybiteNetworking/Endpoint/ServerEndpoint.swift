//
//  ServerEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation

enum ServerEndpoint: Endpoint {
    case signup(SignUpRequest)
    case login(LoginRequest)
    
    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        case .login:
            return "/auth/login"
        }
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Codable? {
        switch self {
        case let .signup(signUpRequest):
            return signUpRequest
        case let .login(loginRequest):
            return loginRequest
        }
    }
}
