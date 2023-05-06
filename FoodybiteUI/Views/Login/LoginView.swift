//
//  ContentView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    let goToSignUp: () -> Void

    public init(viewModel: LoginViewModel, goToSignUp: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.goToSignUp = goToSignUp
    }

    public var body: some View {
        VStack {
            Spacer()
            Text("Foodybite")
                .foregroundColor(.white)
                .font(.system(size: 60))
                .bold()

            Spacer()
            makeTextFields()

            HStack {
                Spacer()
                Text("Forgot Password?")
                    .foregroundColor(.white)
                    .bold()
            }

            Spacer()
            makeLoginButton()
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
        if case let .failure(loginError) = viewModel.state {
            return Text(loginError.rawValue)
                .foregroundColor(.red)
                .font(.headline)
        }

        return Text("")
    }

    @ViewBuilder private func makeTextFields() -> some View {
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
    }

    @ViewBuilder private func makeLoginButton() -> some View {
        MarineButton(title: "Login", isLoading: viewModel.isLoading) {
            Task {
                await viewModel.login()
            }
        }

        createFeedbackText()
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
