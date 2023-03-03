//
//  LoginEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

enum LoginEndpoint: Endpoint {
    case login(LoginRequest)

    public var path: String {
        "/auth/login"
    }
    
    public var method: RequestMethod {
        .post
    }
    
    public var body: Codable? {
        switch self {
        case let .login(body):
            return body
        }
    }
}
