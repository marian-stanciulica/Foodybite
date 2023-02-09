//
//  LoginViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation
import DomainModels

final public class LoginViewModel: ObservableObject {
    public enum LoginError: String, Error {
        case serverError = "Invalid Credentials"
    }
    
    private let loginService: LoginService
    private let goToMainTab: (User) -> Void
    
    @Published public var email = ""
    @Published public var password = ""
    @Published public var loginError: LoginError?
    
    public init(loginService: LoginService, goToMainTab: @escaping (User) -> Void) {
        self.loginService = loginService
        self.goToMainTab = goToMainTab
    }
    
    @MainActor public func login() async {
        do {
            let user = try await loginService.login(email: email, password: password)
            goToMainTab(user)
        } catch {
            loginError = LoginError.serverError
        }
    }
    
}
