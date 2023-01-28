//
//  RestaurantImageView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantImageView: View {
    let phoneNumber: String

    var body: some View {
        ZStack {
            Image("restaurant_logo_test")
                .resizable()
                .aspectRatio(1.2, contentMode: .fit)

            VStack {
                Spacer()
                PhoneAndDirectionsView(phoneNumber: phoneNumber)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
        }
    }
}

struct RestaurantImageView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantImageView(phoneNumber: "+61 2 9374 4000")
            .background(.black)
    }
}
