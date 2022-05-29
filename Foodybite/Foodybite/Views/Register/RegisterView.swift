//
//  RegisterView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct RegisterView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""

    var body: some View {
        VStack {
            ProfileImage()
                .padding(.vertical)

            Group {
            ImageTextField(placeholder: "Name",
                           imageName: "person",
                           text: $email)
            .padding(.bottom)

            ImageTextField(placeholder: "Email",
                           imageName: "envelope",
                           text: $email)
                .padding(.bottom)

            ImageTextField(placeholder: "Password",
                           imageName: "lock.circle",
                           text: $password)
                .padding(.bottom)

            ImageTextField(placeholder: "Confirm Password",
                           imageName: "lock.circle",
                           text: $password)
                .padding(.bottom)
            }

            Spacer()

            MarineButton(title: "Register") {

            }

            Spacer()

            HStack {
                Text("Already have an account?")
                    .foregroundColor(.white)
                Text("Login")
                    .foregroundColor(.marineBlue)
            }
        }
        .padding(.horizontal)
        .background(
            BackgroundImage(imageName: "register_background")
        )
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
