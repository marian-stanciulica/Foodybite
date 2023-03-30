//
//  ImageTextField.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct ImageWhiteTextField: View {
    let placeholder: String
    let imageName: String
    @State var secure: Bool
    @Binding var text: String

    var body: some View {
        HStack {
            Button {
                secure.toggle()
            } label: {
                Image(systemName: imageName)
                    .foregroundColor(.white)
            }

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                }
                
                if secure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .foregroundColor(.white)
        }
        .padding()
        .background(.white.opacity(0.25))
        .cornerRadius(16)
    }

}

struct ImageTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageWhiteTextField(placeholder: "Placeholder",
                                imageName: "envelope",
                                secure: false,
                                text: .constant("Email"))
            .background(.black)
            
            ImageWhiteTextField(placeholder: "Password",
                                imageName: "envelope",
                                secure: true,
                                text: .constant(""))
            .background(.black)
        }
    }
}

