//
//  AccountEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

enum AccountEndpoint: Endpoint {
    case post(UpdateAccountRequestBody)
    case delete

    var path: String {
        "/auth/account"
    }

    var method: RequestMethod {
        switch self {
        case .delete:
            return .delete
        case .post:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case let .post(updateAccountBody):
            return updateAccountBody
        case .delete:
            return nil
        }
    }
}
