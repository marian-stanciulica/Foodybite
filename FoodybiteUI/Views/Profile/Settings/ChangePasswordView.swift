//
//  ChangePassword.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct ChangePasswordView: View {
    @StateObject var viewModel: ChangePasswordViewModel

    public init(viewModel: ChangePasswordViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ImageGrayTextField(placeholder: "Current Password",
                               imageName: "lock.circle",
                               secure: true,
                               text: $viewModel.currentPassword)
            .padding(.bottom)

            ImageGrayTextField(placeholder: "New Password",
                               imageName: "lock.circle",
                               secure: true,
                               text: $viewModel.newPassword)
            .padding(.bottom)

            ImageGrayTextField(placeholder: "Confirm Password",
                               imageName: "lock.circle",
                               secure: true,
                               text: $viewModel.confirmPassword)
            .padding(.bottom)

            createFeedbackText()

            Spacer()

            MarineButton(title: "Update", isLoading: viewModel.isLoading) {
                Task {
                    await viewModel.changePassword()
                }
            }
        }
        .padding()
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .arrowBackButtonStyle()
    }

    private func createFeedbackText() -> Text {
        switch viewModel.result {
        case .success:
            return Text("Password changed successfully!")
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

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePasswordView(
                viewModel: ChangePasswordViewModel(
                    changePasswordService: PreviewChangePasswordService()
                )
            )
        }
    }

    private final class PreviewChangePasswordService: ChangePasswordService {
        func changePassword(currentPassword: String, newPassword: String) async throws { }
    }
}
