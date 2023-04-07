//
//  WhiteButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct WhiteButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
       Button(title, action: action)
            .frame(maxWidth: .infinity, minHeight: 48)
            .foregroundColor(.gray)

            .font(.headline)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
    }
}

struct WhiteButton_Previews: PreviewProvider {
    static var previews: some View {
        WhiteButton(title: "Button") { }
        .padding()
    }
}
