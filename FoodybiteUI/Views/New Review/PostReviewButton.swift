//
//  PostReviewButton.swift
//  FoodybiteUI
//
//  Created by Marian Stanciulica on 26.04.2023.
//

import SwiftUI

struct PostReviewButton: View {
    let title: String
    let isLoading: Bool
    let disabled: Bool
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
        .background(backgroundColor())
        .cornerRadius(16)
        .frame(maxWidth: .infinity, minHeight: 48)
        .disabled(disabled)
        .onTapGesture {
            action()
        }
    }

    private func backgroundColor() -> Color {
        if disabled {
            return .gray
        } else if isLoading {
            return .marineBlue.opacity(0.5)
        }

        return .marineBlue
    }
}

struct PostReviewButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PostReviewButton(title: "Title", isLoading: false, disabled: false) {}
            .padding(.vertical)

            PostReviewButton(title: "Title", isLoading: true, disabled: false) {}
            .padding(.vertical)

            PostReviewButton(title: "Title", isLoading: false, disabled: true) {}
        }
    }
}
