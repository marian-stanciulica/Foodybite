//
//  RefreshTokenEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import SharedAPI

enum RefreshTokenEndpoint: Endpoint {
    case post(RefreshTokenRequest)

    var path: String {
        "/auth/accessToken"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Codable? {
        switch self {
        case let .post(body):
            return body
        }
    }
}
