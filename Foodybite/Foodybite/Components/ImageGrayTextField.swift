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
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                }
                TextField("", text: $text)
            }
            .foregroundColor(.gray)
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
        ImageGrayTextField(placeholder: "Placeholder",
                       imageName: "envelope",
                       text: .constant("Email"))
    }
}
