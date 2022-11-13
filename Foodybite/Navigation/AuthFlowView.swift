//
//  AuthFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import SwiftUI
import FoodybiteNetworking

struct AuthFlowView: View {
    let apiService: APIService
    @ObservedObject var flow: AuthFlow
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            LoginView(viewModel: LoginViewModel(loginService: apiService)) {
                flow.append(AuthFlow.Route.signUp)
            }
            .navigationDestination(for: AuthFlow.Route.self) { route in
                switch route {
                case .signUp:
                    RegisterView(viewModel: RegisterViewModel(signUpService: apiService)) {
                        flow.navigateBack()
                    }
                case .turnOnLocation:
                    TurnOnLocationView()
                }
            }
        }
    }
}
