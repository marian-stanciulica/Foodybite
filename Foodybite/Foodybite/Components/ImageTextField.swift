//
//  ImageTextField.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct ImageTextField: View {
    let placeholder: String
    let imageName: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                }
                TextField("", text: $text)
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
        ImageTextField(placeholder: "Placeholder",
                       imageName: "envelope",
                       text: .constant("Email"))
    }
}

