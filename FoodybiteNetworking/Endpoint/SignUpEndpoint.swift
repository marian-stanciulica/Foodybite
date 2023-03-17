//
//  SignUpEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation
import SharedAPI

enum SignUpEndpoint: Endpoint {
    case post(SignUpRequestBody)
    
    var path: String {
        "/auth/signup"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Codable? {
        switch self {
        case let .post(signUpRequestBody):
            return signUpRequestBody
        }
    }
}
