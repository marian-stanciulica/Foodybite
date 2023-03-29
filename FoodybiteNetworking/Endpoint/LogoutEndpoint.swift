//
//  LogoutEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

struct LogoutEndpoint: Endpoint {
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
