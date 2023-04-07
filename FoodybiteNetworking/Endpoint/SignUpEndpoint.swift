//
//  SignUpEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

struct SignUpEndpoint: Endpoint {
    private let requestBody: SignUpRequestBody

    init(requestBody: SignUpRequestBody) {
        self.requestBody = requestBody
    }

    var path: String {
        "/auth/signup"
    }

    var method: RequestMethod {
        .post
    }

    var body: Encodable? {
        requestBody
    }
}
