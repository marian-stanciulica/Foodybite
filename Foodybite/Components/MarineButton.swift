//
//  RoundedButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct MarineButton: View {
    let title: String
    @Binding var isLoading: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()

            if isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(2)
            }
            
            Button(action: action) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .disabled(isLoading)
            }
            .padding(.vertical)
            
            Spacer()
        }
        .background(isLoading ? Color.marineBlue.opacity(0.5) : Color.marineBlue)
        .cornerRadius(16)
        .frame(maxWidth: .infinity, minHeight: 48)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MarineButton(title: "Title", isLoading: .constant(true)) {
                
            }
            .padding(.vertical)
            
            MarineButton(title: "Title", isLoading: .constant(false)) {
                
            }
        }
    }
}
