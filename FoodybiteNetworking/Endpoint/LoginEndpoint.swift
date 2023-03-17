//
//  LoginEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import SharedAPI

enum LoginEndpoint: Endpoint {
    case post(LoginRequestBody)

    var path: String {
        "/auth/login"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Encodable? {
        switch self {
        case let .post(body):
            return body
        }
    }
}
