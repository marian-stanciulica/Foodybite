//
//  RestaurantCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct RestaurantCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                Image("restaurant_logo_test")
                    .resizable()
                    .scaledToFit()

                HStack {
                    Text("Open")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(.white)
                        )
                        .foregroundColor(.green)

                    Spacer()

                    RatingStar()
                }
                .padding()
            }

            RestaurantInformationView()
        }
        .cornerRadius(16)
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell()
            .background(.blue.opacity(0.2))
            .cornerRadius(16)
            .padding()
    }
}
