//
//  AuthFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import SwiftUI
import FoodybiteNetworking

struct AuthFlowView: View {
    @Binding var userLoggedIn: Bool

    let apiService: APIService
    @ObservedObject var flow: Flow<AuthRoute>
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            LoginView(
                viewModel: LoginViewModel(
                    loginService: apiService,
                    goToMainTab: {
                        userLoggedIn = true
                    }),
                goToSignUp: {
                    flow.append(.signUp)
                }
            )
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
}
