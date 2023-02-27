//
//  ImageGrayTextField.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct ImageGrayTextField: View {
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
                    .foregroundColor(.marineBlue)
            }
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
                
                if secure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
    }
}

struct ImageGrayTextField_Previews: PreviewProvider {
    static var previews: some View {
        ImageGrayTextField(placeholder: "Email",
                           imageName: "envelope", secure: true,
                           text: .constant(""))
    }
}
