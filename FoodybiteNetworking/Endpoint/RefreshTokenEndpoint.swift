//
//  RefreshTokenEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

struct RefreshTokenEndpoint: Endpoint {
    private let requestBody: RefreshTokenRequestBody
    
    init(requestBody: RefreshTokenRequestBody) {
        self.requestBody = requestBody
    }

    var path: String {
        "/auth/accessToken"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Encodable? {
        requestBody
    }
}
