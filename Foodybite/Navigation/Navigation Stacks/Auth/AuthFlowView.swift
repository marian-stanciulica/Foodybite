//
//  AuthFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import SwiftUI
import Domain
import FoodybiteNetworking

struct AuthFlowView: View {
    @ObservedObject var flow: Flow<AuthRoute>
    let apiService: APIService
    let goToMainTab: (User) -> Void
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            makeLoginView(flow: flow, loginService: apiService, goToMainTab: goToMainTab)
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signUp:
                    RegisterView(viewModel: RegisterViewModel(signUpService: apiService)) {
                        flow.navigateBack()
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func makeLoginView(
        flow: Flow<AuthRoute>,
        loginService: LoginService,
        goToMainTab: @escaping (User) -> Void
    ) -> some View {
        LoginView(
            viewModel: LoginViewModel(
                loginService: loginService,
                goToMainTab: goToMainTab),
            goToSignUp: {
                flow.append(.signUp)
            }
        )
    }
}
