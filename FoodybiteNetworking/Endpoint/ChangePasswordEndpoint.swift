//
//  ChangePasswordEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import SharedAPI

enum ChangePasswordEndpoint: Endpoint {
    case post(ChangePasswordRequestBody)
    
    var path: String {
        "/auth/changePassword"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Codable? {
        switch self {
        case let .post(changePasswordBody):
            return changePasswordBody
        }
    }
}
