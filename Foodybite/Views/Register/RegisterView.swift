//
//  RegisterView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack {
            ProfileImage()
                .padding(.bottom)

            Spacer()

            Group {
                ImageWhiteTextField(placeholder: "Name",
                                    imageName: "person",
                                    secure: false,
                                    text: $viewModel.name)
                
                ImageWhiteTextField(placeholder: "Email",
                                    imageName: "envelope",
                                    secure: false,
                                    text: $viewModel.email)
                
                ImageWhiteTextField(placeholder: "Password",
                                    imageName: "lock.circle",
                                    secure: true,
                                    text: $viewModel.password)
                
                ImageWhiteTextField(placeholder: "Confirm Password",
                                    imageName: "lock.circle",
                                    secure: true,
                                    text: $viewModel.confirmPassword)
            }
            .padding(.bottom)

            Spacer()

            MarineButton(title: "Register") {
                Task {
                    await viewModel.register()
                }
            }
        
            switch viewModel.registerResult {
            case .success:
                Text("Registration succedeed")
                    .foregroundColor(.white)
                    .font(.headline)
            case let .failure(error):
                Text(error.rawValue)
                    .foregroundColor(.red)
                    .font(.headline)
            case .notTriggered:
                Text("")
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
        .arrowBackButtonStyle()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                RegisterView(viewModel:
                                RegisterViewModel(
                                    signUpService: PreviewSignUpService()
                                )
                )
            }
        }
    }
    
    private class PreviewSignUpService: SignUpService, ObservableObject {
        func signUp(name: String, email: String, password: String, confirmPassword: String) async throws {
        }
    }
}
