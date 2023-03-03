//
//  RefreshTokenEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

enum RefreshTokenEndpoint: Endpoint {
    case refreshToken(RefreshTokenRequest)

    public var path: String {
        "/auth/accessToken"
    }
    
    public var method: RequestMethod {
        .post
    }
    
    public var body: Codable? {
        switch self {
        case let .refreshToken(body):
            return body
        }
    }
}
