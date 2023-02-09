//
//  ProfileFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Domain
import SwiftUI
import FoodybiteNetworking

struct ProfileFlowView: View {
    @Binding var page: Page
    @ObservedObject var flow: Flow<ProfileRoute>
    @AppStorage("userLoggedIn") var userLoggedIn = false
    let apiService: APIService
    let user: User
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $page) {
                ProfileView(
                    viewModel: ProfileViewModel(
                        accountService: apiService,
                        getReviewsService: apiService,
                        user: user,
                        goToLogin: { userLoggedIn = false }
                    ),
                    goToSettings: { flow.append(.settings) },
                    goToEditProfile: { flow.append(.editProfile) }
                )
            }
            .navigationDestination(for: ProfileRoute.self) { route in
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
                case .editProfile:
                    EditProfileView(viewModel: EditProfileViewModel(accountService: apiService))
                }
            }
        }
    }
}
