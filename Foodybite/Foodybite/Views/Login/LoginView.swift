//
//  ContentView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            Spacer()
            Text("Foodybite")
                .foregroundColor(.white)
                .font(.system(size: 60))
                .bold()

            Spacer()

            ImageTextField(placeholder: "Email",
                           imageName: "envelope",
                           text: $email)

            ImageTextField(placeholder: "Password",
                           imageName: "lock.circle",
                           text: $password)

            HStack {
                Spacer()
                Text("Forgot Password?")
                    .foregroundColor(.white)
                    .bold()
            }

            Spacer()

            Button("Login") {

            }
            .frame(maxWidth: .infinity, minHeight: 54)
            .foregroundColor(.white)
            .background(Color.marineBlue)
            .cornerRadius(16)
            .font(.headline)

            Spacer()

            Text("Create New Account")
                .foregroundColor(.white)
                .underline()
        }
        .padding(.horizontal)
        .background(
            LoginBackground()
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
