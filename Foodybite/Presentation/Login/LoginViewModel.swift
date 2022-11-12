//
//  LoginViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import FoodybiteNetworking

final public class LoginViewModel {
    public enum LoginError: Error {
        case serverError
    }
    
    private let loginService: LoginService
    
    public var email = ""
    public var password = ""
    public var loginError: LoginError?
    
    public init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    public func login() async {
        do {
            _ = try await loginService.login(email: email, password: password)
        } catch {
            loginError = .serverError
        }
    }
}
