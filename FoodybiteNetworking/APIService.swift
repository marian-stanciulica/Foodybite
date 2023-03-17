//
//  APIService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation
import Domain
import SharedAPI

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
    public func login(email: String, password: String) async throws -> User {
        let endpoint = LoginEndpoint.post(LoginRequestBody(email: email, password: password))
        let urlRequest = try endpoint.createURLRequest()
        let loginResponse: LoginResponse = try await loader.get(for: urlRequest)
        
        try tokenStore.write(loginResponse.token)
        
        return loginResponse.remoteUser.model
    }
}

extension APIService: SignUpService {
    public func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {
        let body = SignUpRequestBody(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            profileImage: profileImage
        )
        let endpoint = SignUpEndpoint.post(body)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: ChangePasswordService {
    public func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        let changePasswordRequest = ChangePasswordRequest(currentPassword: currentPassword,
                                                          newPassword: newPassword,
                                                          confirmPassword: confirmPassword)
        let endpoint = ChangePasswordEndpoint.post(changePasswordRequest)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: LogoutService {
    public func logout() async throws {
        let endpoint = LogoutEndpoint.post
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: AccountService {
    public func updateAccount(name: String, email: String, profileImage: Data?) async throws {
        let updateAccountRequest = UpdateAccountRequest(name: name, email: email, profileImage: profileImage)
        let endpoint = AccountEndpoint.post(updateAccountRequest)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
    
    public func deleteAccount() async throws {
        let endpoint = AccountEndpoint.delete
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: AddReviewService {
    public func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
        let requestBody = AddReviewRequest(placeID: placeID, text: reviewText, stars: starsNumber, createdAt: createdAt)
        let endpoint = ReviewEndpoint.post(requestBody)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: GetReviewsService {
    public func getReviews(placeID: String? = nil) async throws -> [Review] {
        let endpoint = ReviewEndpoint.get(placeID)
        let urlRequest = try endpoint.createURLRequest()
        let response: [RemoteReview] = try await loader.get(for: urlRequest)
        return response.map { $0.review }
    }
}
