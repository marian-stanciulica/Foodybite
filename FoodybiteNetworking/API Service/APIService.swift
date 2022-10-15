//
//  APIService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

class APIService: LoginService {
    private let loader: ResourceLoader
    
    init(loader: ResourceLoader) {
        self.loader = loader
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = ServerEndpoint.login(email: email, password: password)
        let urlRequest = try endpoint.createURLRequest()
        return try await loader.get(for: urlRequest)
    }
}
