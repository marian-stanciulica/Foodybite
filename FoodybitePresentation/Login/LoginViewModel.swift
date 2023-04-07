//
//  LoginViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation
import Domain

final public class LoginViewModel: ObservableObject {
    public enum LoginError: String, Error {
        case serverError = "Invalid Credentials"
    }

    public enum State: Equatable {
        case idle
        case isLoading
        case success
        case failure(LoginError)
    }

    private let loginService: LoginService
    private let goToMainTab: (User) -> Void

    @Published public var email = ""
    @Published public var password = ""
    @Published public var state: State = .idle

    public var isLoading: Bool {
        state == .isLoading
    }

    public init(loginService: LoginService, goToMainTab: @escaping (User) -> Void) {
        self.loginService = loginService
        self.goToMainTab = goToMainTab
    }

    @MainActor public func login() async {
        state = .isLoading

        do {
            let user = try await loginService.login(email: email, password: password)
            goToMainTab(user)
        } catch {
            state = .failure(.serverError)
        }
    }

}
