//
//  ContentView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import Domain

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    let goToSignUp: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Foodybite")
                .foregroundColor(.white)
                .font(.system(size: 60))
                .bold()

            Spacer()

            Group {
                ImageWhiteTextField(placeholder: "Email",
                                    imageName: "envelope",
                                    secure: false,
                                    text: $viewModel.email)
                
                ImageWhiteTextField(placeholder: "Password",
                                    imageName: "lock.circle",
                                    secure: true,
                                    text: $viewModel.password)
            }
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
            
            createFeedbackText()

            Spacer()

            Button {
                goToSignUp()
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
    
    private func createFeedbackText() -> Text {
        if let loginError = viewModel.loginError {
            return Text(loginError.rawValue)
                .foregroundColor(.red)
                .font(.headline)
        }
        
        return Text("")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(viewModel: LoginViewModel(loginService: PreviewLoginService(), goToMainTab: { _ in })) {
                
            }
        }
    }
    
    private class PreviewLoginService: LoginService {
        func login(email: String, password: String) async throws -> User {
            throw LoginViewModel.LoginError.serverError
        }
    }
}
