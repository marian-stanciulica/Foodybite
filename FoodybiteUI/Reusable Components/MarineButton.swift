//
//  RoundedButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct MarineButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()

            if isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(2)
            }

            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .disabled(isLoading)
                .padding(.vertical)

            Spacer()
        }
        .background(isLoading ? Color.marineBlue.opacity(0.5) : Color.marineBlue)
        .cornerRadius(16)
        .frame(maxWidth: .infinity, minHeight: 48)
        .onTapGesture {
            action()
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MarineButton(title: "Title", isLoading: true) {}
            .padding(.vertical)

            MarineButton(title: "Title", isLoading: false) {}
        }
    }
}
