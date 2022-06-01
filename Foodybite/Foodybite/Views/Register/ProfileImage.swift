//
//  ProfileImage.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct ProfileImage: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.25))

                Image(systemName: "person")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }

            Image(systemName: "arrow.up")
                .padding()
                .overlay(Circle().stroke(.white, lineWidth: 3))
                .foregroundColor(.white)
                .background(Circle().fill(Color.marineBlue))
                .font(.system(size: 30, weight: .bold))
            }
        .frame(width: 180, height: 180)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage()
            .background(.black)
    }
}
