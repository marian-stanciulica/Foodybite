//
//  RegisterView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    let goToLogin: () -> Void

    public init(viewModel: RegisterViewModel, goToLogin: @escaping () -> Void) {
        self.viewModel = viewModel
        self.goToLogin = goToLogin
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            ProfileImage(backgroundColor: .white,
                         selectedImageData: $viewModel.profileImage)
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

            MarineButton(title: "Register", isLoading: viewModel.isLoading) {
                Task {
                    await viewModel.register()
                }
            }
            
            createFeedbackText()

            Spacer()

            HStack {
                Text("Already have an account?")
                    .foregroundColor(.white)
                
                Button {
                    goToLogin()
                } label: {
                    Text("Login")
                        .foregroundColor(.marineBlue)
                }
            }
        }
        .padding(.horizontal)
        .background(
            BackgroundImage(imageName: "register_background")
        )
        .arrowBackButtonStyle()
    }
    
    private func createFeedbackText() -> Text {
        switch viewModel.registerResult {
        case .success:
            return Text("Registration succedeed")
                .foregroundColor(.green)
                .font(.headline)
            
        case let .failure(error):
            return Text(error.toString())
                .foregroundColor(.red)
                .font(.headline)
            
        default:
            return Text("")
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterView(viewModel:
                RegisterViewModel(
                    signUpService: PreviewSignUpService()
                )
            ) { }
        }
    }
    
    private class PreviewSignUpService: SignUpService, ObservableObject {
        func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {
        }
    }
}