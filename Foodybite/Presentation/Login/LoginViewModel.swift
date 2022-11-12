//
//  LoginViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Combine
import FoodybiteNetworking

final public class LoginViewModel: ObservableObject {
    public enum LoginError: Error {
        case serverError
    }
    
    private let loginService: LoginService
    
    @Published public var email = ""
    @Published public var password = ""
    @Published public var loginError: LoginError?
    
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
