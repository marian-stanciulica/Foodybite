//
//  LoginBackground.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct BackgroundImage: View {
    let imageName: String

    var body: some View {
        Image(imageName, bundle: .current)
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
        BackgroundImage(imageName: "login_background")
    }
}
