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
    
    public var path: String {
        "/auth/logout"
    }
    
    public var method: RequestMethod {
        .post
    }
    
    public var body: Codable? {
        nil
    }
}
