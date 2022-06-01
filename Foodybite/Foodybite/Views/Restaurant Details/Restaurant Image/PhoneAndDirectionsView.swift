//
//  PhoneAndDirectionsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct PhoneAndDirectionsView: View {
    var body: some View {
        HStack {
            Spacer()

            Image(systemName: "star")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.white)
                .frame(height: 32)

            Text("+1 212-673-3754")
                .foregroundColor(.white)

            Spacer()
            Rectangle()
                .frame(width: 1)
                .foregroundColor(.white.opacity(0.25))
            Spacer()

            Image(systemName: "arrow.uturn.right.circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.white)
                .frame(height: 32)

            Text("Direction")
                .foregroundColor(.white)

            Spacer()
        }
        .frame(height: 54)
        .background(Blur(style: .regular).cornerRadius(27))
    }
}

struct PhoneAndDirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAndDirectionsView()
            .padding()
            .background(
                Image("restaurant_logo_test")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            )
    }
}