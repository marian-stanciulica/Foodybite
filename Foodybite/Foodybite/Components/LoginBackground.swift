//
//  LoginBackground.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct LoginBackground: View {
    var body: some View {
        Image("login_background")
            .resizable()
            .saturation(0.5)
            .scaledToFill()
            .overlay(
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
            )
            .ignoresSafeArea()
    }
}

struct LoginBackground_Previews: PreviewProvider {
    static var previews: some View {
        LoginBackground()
    }
}
