//
//  OrangeButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct OrangeButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
       Button(title, action: action)
           .frame(maxWidth: .infinity, minHeight: 54)
           .foregroundColor(.white)
           .background(Color.orange.opacity(0.5))
           .cornerRadius(16)
           .font(.headline)
    }
}

struct OrangeButton_Previews: PreviewProvider {
    static var previews: some View {
        OrangeButton(title: "Button") { }
    }
}
