//
//  AccountEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation

enum AccountEndpoint: Endpoint {
    case post(UpdateAccountRequest)
    case delete
    
    public var path: String {
        "/auth/account"
    }
    
    public var method: RequestMethod {
        switch self {
        case .delete:
            return .delete
        case .post:
            return .post
        }
    }
    
    public var body: Codable? {
        switch self {
        case let .post(updateAccountBody):
            return updateAccountBody
        case .delete:
            return nil
        }
    }
}
