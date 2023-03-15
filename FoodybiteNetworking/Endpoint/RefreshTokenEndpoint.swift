//
//  RefreshTokenEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import SharedAPI

enum RefreshTokenEndpoint: Endpoint {
    case post(RefreshTokenRequest)

    public var path: String {
        "/auth/accessToken"
    }
    
    public var method: RequestMethod {
        .post
    }
    
    public var body: Codable? {
        switch self {
        case let .post(body):
            return body
        }
    }
}
