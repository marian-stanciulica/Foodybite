//
//  RoundedButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct MarineButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 48)
                .foregroundColor(.white)
                .background(Color.marineBlue)
                .cornerRadius(16)
                .font(.headline)
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        MarineButton(title: "Title") {
            
        }
    }
}
