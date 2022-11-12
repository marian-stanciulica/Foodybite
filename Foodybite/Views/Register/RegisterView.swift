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
                                    text: $viewModel.name)
                
                ImageWhiteTextField(placeholder: "Email",
                                    imageName: "envelope",
                                    text: $viewModel.email)
                
                ImageWhiteTextField(placeholder: "Password",
                                    imageName: "lock.circle",
                                    text: $viewModel.password)
                
                ImageWhiteTextField(placeholder: "Confirm Password",
                                    imageName: "lock.circle",
                                    text: $viewModel.confirmPassword)
            }
            .padding(.bottom)

            Spacer()

            MarineButton(title: "Register") {
                Task {
                    await viewModel.register()
                }
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
