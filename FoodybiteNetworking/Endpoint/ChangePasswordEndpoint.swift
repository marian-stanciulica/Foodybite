//
//  ChangePasswordEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation

enum ChangePasswordEndpoint: Endpoint {
    case post(ChangePasswordRequest)
    
    public var path: String {
        "/auth/changePassword"
    }
    
    public var method: RequestMethod {
        .post
    }
    
    public var body: Codable? {
        switch self {
        case let .post(changePasswordBody):
            return changePasswordBody
        }
    }
}
