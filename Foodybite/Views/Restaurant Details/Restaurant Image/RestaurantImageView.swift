//
//  RestaurantImageView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantImageView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Image("restaurant_logo_test")
                .resizable()
                .aspectRatio(1.2, contentMode: .fit)

            HStack {
                Spacer()

                Button {

                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.white)
                }
                .frame(width: 32, height: 32)

                Button {

                } label: {
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.white)
                }
                .frame(width: 32, height: 32)
                .padding()
            }
            .padding()

            VStack {
                Spacer()
                PhoneAndDirectionsView()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
        }
    }
}

struct RestaurantImageView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantImageView()
    }
}
