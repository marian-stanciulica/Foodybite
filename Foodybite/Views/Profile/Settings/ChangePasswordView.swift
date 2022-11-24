//
//  ChangePassword.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct ChangePasswordView: View {
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var confirmPassword = ""

    var body: some View {
        VStack {
            ImageGrayTextField(placeholder: "Current Password",
                               imageName: "lock.circle",
                               text: $currentPassword)
            .padding(.bottom)

            ImageGrayTextField(placeholder: "New Password",
                               imageName: "lock.circle",
                               text: $newPassword)
            .padding(.bottom)

            ImageGrayTextField(placeholder: "Confirm Password",
                               imageName: "lock.circle",
                               text: $confirmPassword)
            .padding(.bottom)

            Spacer()

            MarineButton(title: "Update") {

            }
        }
        .padding()
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .arrowBackButtonStyle()
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePasswordView()
        }
    }
}
