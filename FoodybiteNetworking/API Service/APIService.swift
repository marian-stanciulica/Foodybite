//
//  APIService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

public class APIService {
    private let loader: ResourceLoader
    private let sender: ResourceSender
    
    public init(loader: ResourceLoader, sender: ResourceSender) {
        self.loader = loader
        self.sender = sender
    }
}

extension APIService: LoginService {
    public func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = ServerEndpoint.login(LoginRequest(email: email, password: password))
        let urlRequest = try endpoint.createURLRequest()
        return try await loader.get(for: urlRequest)
    }
}

extension APIService: SignUpService {
    public func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {
        let endpoint = ServerEndpoint.signup(SignUpRequest(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage))
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}
