//
//  EditProfileView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import SwiftUI

struct EditProfileView: View {
    @State var profileImage: Data? = nil
    @State var name: String = ""
    @State var email: String = ""
    
    var body: some View {
        VStack {
            ProfileImage(backgroundColor: .black,
                         selectedImageData: $profileImage)
                .padding(.vertical, 40)

            Group {
                ImageGrayTextField(placeholder: "Name",
                                    imageName: "person",
                                    secure: false,
                                    text: $name)
                
                ImageGrayTextField(placeholder: "Email",
                                    imageName: "envelope",
                                    secure: false,
                                    text: $email)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)

            MarineButton(title: "Update") {
                
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            Spacer()
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .arrowBackButtonStyle()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfileView()
        }
    }
}
