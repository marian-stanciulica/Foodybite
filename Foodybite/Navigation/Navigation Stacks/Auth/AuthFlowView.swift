//
//  AuthFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

struct AuthFlowView {
    
    @ViewBuilder static func makeLoginView(
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
