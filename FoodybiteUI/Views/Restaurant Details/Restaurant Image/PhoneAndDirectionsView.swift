//
//  PhoneAndDirectionsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct PhoneAndDirectionsView: View {
    let phoneNumber: String?
    let showMaps: () -> Void

    var body: some View {
        HStack {
            if let phoneNumber = phoneNumber {
                Spacer()

                Image(systemName: "star")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(height: 24)


                Text(phoneNumber)
                    .font(.callout)
                    .foregroundColor(.white)

                Spacer()
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.white.opacity(0.25))
            }

            Spacer()

            Group {
                Image(systemName: "arrow.uturn.right.circle")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(height: 24)

                Text("Direction")
                    .font(.callout)
                    .foregroundColor(.white)
            }
            .onTapGesture(perform: showMaps)

            Spacer()
        }
        .frame(height: 54)
        .background(Blur(style: .regular).cornerRadius(27))
    }
}

struct PhoneAndDirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAndDirectionsView(phoneNumber: nil, showMaps: {})
            .padding()
            .background(
                Image("restaurant_logo_test")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            )
    }
}
