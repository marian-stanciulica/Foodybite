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
    @StateObject var viewModel: RegisterViewModel
    let goToLogin: () -> Void

    public init(viewModel: RegisterViewModel, goToLogin: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.goToLogin = goToLogin
    }

    public var body: some View {
        VStack {
            Spacer()

            ProfileImage(backgroundColor: .white,
                         selectedImageData: $viewModel.profileImage)
                .padding(.bottom)

            Spacer()

            makeTextFields()

            Spacer()

            MarineButton(title: "Register", isLoading: viewModel.isLoading) {
                Task {
                    await viewModel.register()
                }
            }

            createFeedbackText()

            Spacer()

            makeAlreadyHaveAccount()
        }
        .padding(.horizontal)
        .background(
            BackgroundImage(imageName: "register_background")
        )
        .arrowBackButtonStyle(color: .white)
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

    @ViewBuilder private func makeTextFields() -> some View {
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
    }

    @ViewBuilder private func makeAlreadyHaveAccount() -> some View {
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

    private final class PreviewSignUpService: SignUpService, ObservableObject {
        func signUp(name: String, email: String, password: String, profileImage: Data?) async throws {
        }
    }
}
