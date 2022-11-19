//
//  LoginViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Combine
import FoodybiteNetworking

final public class LoginViewModel: ObservableObject {
    public enum LoginError: String, Error {
        case serverError = "Invalid Credentials"
    }
    
    private let loginService: LoginService
    private let goToMainTab: () -> Void
    
    @Published public var email = ""
    @Published public var password = ""
    @Published public var loginError: LoginError?
    
    public init(loginService: LoginService, goToMainTab: @escaping () -> Void) {
        self.loginService = loginService
        self.goToMainTab = goToMainTab
    }
    
    public func login() async {
        do {
            _ = try await loginService.login(email: email, password: password)            
            await goToMainTabScreen()
        } catch {
            await updateLoginError(.serverError)
        }
    }
    
    @MainActor private func updateLoginError(_ newValue: LoginError) {
        loginError = newValue
    }
    
    @MainActor private func goToMainTabScreen() {
        goToMainTab()
    }
}
