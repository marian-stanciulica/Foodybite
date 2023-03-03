//
//  SignUpEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation

enum SignUpEndpoint: Endpoint {
    case post(SignUpRequest)
    
    var path: String {
        "/auth/signup"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Codable? {
        switch self {
        case let .post(signUpRequest):
            return signUpRequest
        }
    }
}
