//
//  SettingsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import FoodybiteNetworking

struct SettingsView: View {
    let viewModel: SettingsViewModel
    let goToChangePassword: () -> Void
    @State var logoutAlertDisplayed = false

    var body: some View {
        List {
            Section("Account") {
                HStack {
                    Text("Change password")
                    
                    Spacer()
                    
                    Button {
                        goToChangePassword()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section("Others") {
                Button("Logout") {
                    logoutAlertDisplayed = true
                }
                .foregroundColor(.marineBlue)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Are you sure you want to logout?", isPresented: $logoutAlertDisplayed) {
            Button("No", role: .cancel) { }
            Button("Yes") {
                Task {
                    await viewModel.logout()
                }
            }
        }
        .arrowBackButtonStyle()
    }
}

struct SeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            viewModel: SettingsViewModel(logoutService: PreviewLogoutService(),
                                         goToLogin: {}),
            goToChangePassword: {}
        )
    }
    
    private class PreviewLogoutService: LogoutService {
        func logout() async throws {}
    }
}
