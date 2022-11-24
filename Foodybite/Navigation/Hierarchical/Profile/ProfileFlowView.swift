//
//  ProfileFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import SwiftUI
import FoodybiteNetworking

struct ProfileFlowView: View {
    @ObservedObject var flow: ProfileFlow
    @AppStorage("userLoggedIn") var userLoggedIn = false
    let apiService: APIService
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            ProfileView {
                flow.append(.settings)
            }
            .navigationDestination(for: ProfileFlow.Route.self) { route in
                switch route {
                case .settings:
                    SettingsView(
                        viewModel: SettingsViewModel(
                            logoutService: apiService,
                            goToLogin: { userLoggedIn = false }
                        )
                    ) {
                        flow.append(.changePassword)
                    }
                case .changePassword:
                    ChangePasswordView(viewModel: ChangePasswordViewModel(changePasswordService: apiService))
                }
            }
        }
    }
}
