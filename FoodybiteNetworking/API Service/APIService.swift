//
//  APIService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

class APIService: LoginService {
    private let loader: ResourceLoader
    private let sender: ResourceSender
    
    init(loader: ResourceLoader, sender: ResourceSender) {
        self.loader = loader
        self.sender = sender
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = ServerEndpoint.login(email: email, password: password)
        let urlRequest = try endpoint.createURLRequest()
        return try await loader.get(for: urlRequest)
    }
}

extension APIService: SignUpService {
    func signUp(name: String, email: String, password: String, confirmPassword: String) async throws {
        let endpoint = ServerEndpoint.signup(name: name, email: email, password: password, confirmPassword: confirmPassword)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}
