//
//  APIService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation
import Domain

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
        let hashedPassword = SHA512PasswordHasher.hash(password: password)
        let body = LoginRequestBody(email: email, password: hashedPassword)
        let endpoint = LoginEndpoint(requestBody: body)
        let urlRequest = try endpoint.createURLRequest()
        let loginResponse: LoginResponse = try await loader.get(for: urlRequest)

        try tokenStore.write(loginResponse.token)

        return loginResponse.remoteUser.model
    }
}

extension APIService: SignUpService {
    public func signUp(name: String, email: String, password: String, profileImage: Data?) async throws {
        let hashedPassword = SHA512PasswordHasher.hash(password: password)

        let body = SignUpRequestBody(
            name: name,
            email: email,
            password: hashedPassword,
            profileImage: profileImage
        )
        let endpoint = SignUpEndpoint(requestBody: body)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: ChangePasswordService {
    public func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        let hashedCurrentPassword = SHA512PasswordHasher.hash(password: currentPassword)
        let hashedNewPassword = SHA512PasswordHasher.hash(password: newPassword)
        let hashedConfirmPassword = SHA512PasswordHasher.hash(password: confirmPassword)

        let body = ChangePasswordRequestBody(currentPassword: hashedCurrentPassword,
                                             newPassword: hashedNewPassword,
                                             confirmPassword: hashedConfirmPassword)
        let endpoint = ChangePasswordEndpoint(requestBody: body)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: LogoutService {
    public func logout() async throws {
        let endpoint = LogoutEndpoint()
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: AccountService {
    public func updateAccount(name: String, email: String, profileImage: Data?) async throws {
        let updateAccountRequest = UpdateAccountRequestBody(name: name, email: email, profileImage: profileImage)
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
    public func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
        let requestBody = AddReviewRequestBody(restaurantID: restaurantID, text: reviewText, stars: starsNumber, createdAt: createdAt)
        let endpoint = ReviewEndpoint.post(requestBody)
        let urlRequest = try endpoint.createURLRequest()
        try await sender.post(to: urlRequest)
    }
}

extension APIService: GetReviewsService {
    public func getReviews(restaurantID: String? = nil) async throws -> [Review] {
        let endpoint = ReviewEndpoint.get(restaurantID)
        let urlRequest = try endpoint.createURLRequest()
        let response: [RemoteReview] = try await loader.get(for: urlRequest)
        return response.map { $0.review }
    }
}
