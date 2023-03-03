//
//  AccountEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation

enum AccountEndpoint: Endpoint {
    case updateAccount(UpdateAccountRequest)
    case deleteAccount
    
    public var path: String {
        "/auth/account"
    }
    
    public var method: RequestMethod {
        switch self {
        case .deleteAccount:
            return .delete
        case .updateAccount:
            return .post
        }
    }
    
    public var body: Codable? {
        switch self {
        case let .updateAccount(updateAccountBody):
            return updateAccountBody
        case .deleteAccount:
            return nil
        }
    }
}
