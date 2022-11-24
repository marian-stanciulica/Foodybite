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
    private let tokenStore: TokenStore
    
    public init(loader: ResourceLoader, sender: ResourceSender, tokenStore: TokenStore) {
        self.loader = loader
        self.sender = sender
        self.tokenStore = tokenStore
    }
}

extension APIService: LoginService {
    public func login(email: String, password: String) async throws -> RemoteUser {
        let endpoint = ServerEndpoint.login(LoginRequest(email: email, password: password))
        let urlRequest = try endpoint.createURLRequest()
        let loginResponse: LoginResponse = try await loader.get(for: urlRequest)
        
        try tokenStore.write(loginResponse.token)
        
        return loginResponse.user
    }
}

extension APIService: SignUpService {
    public func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {
        let endpoint = ServerEndpoint.signup(SignUpRequest(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage))
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: ChangePasswordService {
    public func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        let changePasswordRequest = ChangePasswordRequest(currentPassword: currentPassword,
                                                          newPassword: newPassword,
                                                          confirmPassword: confirmPassword)
        let endpoint = ServerEndpoint.changePassword(changePasswordRequest)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: LogoutService {
    public func logout() async throws {
        let endpoint = ServerEndpoint.logout
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}
