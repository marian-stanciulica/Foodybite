//
//  SettingsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @State var logoutAlertDisplayed = false

    var body: some View {
        List {
            Section("Account") {
                NavigationLink {
                    ChangePasswordView()
                } label: {
                    Text("Change Password")
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
            Button("Yes") { }
        }
        .arrowBackButtonStyle()
    }
}

struct SeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
