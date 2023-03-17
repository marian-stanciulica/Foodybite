//
//  LogoutEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import SharedAPI

enum LogoutEndpoint: Endpoint {
    case post
    
    var path: String {
        "/auth/logout"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Encodable? {
        nil
    }
}
