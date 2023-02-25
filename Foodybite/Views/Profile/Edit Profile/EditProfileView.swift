//
//  EditProfileView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import SwiftUI
import Domain

struct EditProfileView: View {
    @ObservedObject var viewModel: EditProfileViewModel
    
    var body: some View {
        VStack {
            ProfileImage(backgroundColor: .black,
                         selectedImageData: $viewModel.profileImage)
                .padding(.vertical, 40)

            Group {
                ImageGrayTextField(placeholder: "Name",
                                   imageName: "person",
                                   secure: false,
                                   text: $viewModel.name)
                
                ImageGrayTextField(placeholder: "Email",
                                   imageName: "envelope",
                                   secure: false,
                                   text: $viewModel.email)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)

            MarineButton(title: "Update", isLoading: false) {
                Task {
                    await viewModel.updateAccount()
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            createFeedbackText()
                .padding(.vertical)
            
            Spacer()
            Spacer()
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .arrowBackButtonStyle()
    }
    
    private func createFeedbackText() -> Text {
        switch viewModel.result {
        case .success:
            return Text("Account updated!")
                .foregroundColor(.green)
                .font(.headline)
            
        case let .failure(error):
            return Text(error.rawValue)
                .foregroundColor(.red)
                .font(.headline)

        case .notTriggered:
            return Text("")
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfileView(
                viewModel: EditProfileViewModel(
                    accountService: PreviewAccountService()
                )
            )
        }
    }
    
    private class PreviewAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }
}
