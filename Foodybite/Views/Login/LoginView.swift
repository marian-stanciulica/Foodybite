//
//  ContentView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("userLoggedIn") var userLoggedIn = false
    @State var email = ""
    @State var password = ""

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Foodybite")
                    .foregroundColor(.white)
                    .font(.system(size: 60))
                    .bold()

                Spacer()

                ImageWhiteTextField(placeholder: "Email",
                                    imageName: "envelope",
                                    secure: false,
                                    text: $email)
                    .padding(.bottom)

                ImageWhiteTextField(placeholder: "Password",
                                    imageName: "lock.circle",
                                    secure: true,
                                    text: $password)
                    .padding(.bottom)

                HStack {
                    Spacer()
                    Text("Forgot Password?")
                        .foregroundColor(.white)
                        .bold()
                }

                Spacer()

                MarineButton(title: "Login") {
                    userLoggedIn = true
                }

                Spacer()

                NavigationLink {
                    
                } label: {
                    Text("Create New Account")
                        .foregroundColor(.white)
                        .underline()
                }
            }
            .padding(.horizontal)
            .background(
                BackgroundImage(imageName: "login_background")
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
