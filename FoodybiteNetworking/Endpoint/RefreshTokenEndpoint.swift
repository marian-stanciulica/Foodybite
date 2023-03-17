//
//  RefreshTokenEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import SharedAPI

enum RefreshTokenEndpoint: Endpoint {
    case post(RefreshTokenRequestBody)

    var path: String {
        "/auth/accessToken"
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
