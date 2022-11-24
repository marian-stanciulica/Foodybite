//
//  SettingsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @State var logoutAlertDisplayed = false
    let goToChangePassword: () -> Void

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
            Button("Yes") { }
        }
        .arrowBackButtonStyle()
    }
}

struct SeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView() {}
    }
}
