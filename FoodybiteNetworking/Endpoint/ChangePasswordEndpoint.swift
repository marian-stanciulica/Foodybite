//
//  ChangePasswordEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import SharedAPI

struct ChangePasswordEndpoint: Endpoint {
    private let requestBody: ChangePasswordRequestBody
    
    init(requestBody: ChangePasswordRequestBody) {
        self.requestBody = requestBody
    }
    
    var path: String {
        "/auth/changePassword"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Encodable? {
        requestBody
    }
}
