//
//  LoginEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 03.03.2023.
//

struct LoginEndpoint: Endpoint {
    private let requestBody: LoginRequestBody

    init(requestBody: LoginRequestBody) {
        self.requestBody = requestBody
    }

    var path: String {
        "/auth/login"
    }

    var method: RequestMethod {
        .post
    }

    var body: Encodable? {
        requestBody
    }
}
