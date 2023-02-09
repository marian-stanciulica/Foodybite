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
            LoginView(
                viewModel: LoginViewModel(
                    loginService: apiService,
                    goToMainTab: goToMainTab),
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
