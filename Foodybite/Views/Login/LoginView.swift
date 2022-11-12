//
//  ContentView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

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
                                    text: $viewModel.email)
                    .padding(.bottom)

                ImageWhiteTextField(placeholder: "Password",
                                    imageName: "lock.circle",
                                    secure: true,
                                    text: $viewModel.password)
                    .padding(.bottom)

                HStack {
                    Spacer()
                    Text("Forgot Password?")
                        .foregroundColor(.white)
                        .bold()
                }

                Spacer()

                MarineButton(title: "Login") {
                    Task {
                        await viewModel.login()
                    }
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
        NavigationView {
            LoginView(viewModel:
                LoginViewModel(
                    loginService: PreviewLoginService()
                )
            )
        }
    }
    
    private class PreviewLoginService: LoginService {
        func login(email: String, password: String) async throws -> LoginResponse {
            return LoginResponse(name: "name", email: "email")
        }
    }
}
