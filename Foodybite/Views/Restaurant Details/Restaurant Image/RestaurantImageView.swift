//
//  RestaurantImageView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantImageView: View {
    var body: some View {
        ZStack {
            Image("restaurant_logo_test")
                .resizable()
                .aspectRatio(1.2, contentMode: .fit)

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
            .background(.black)
    }
}
