//
//  RestaurantCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import DomainModels
import SwiftUI

struct RestaurantCell: View {
    let place: NearbyPlace
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                Image("restaurant_logo_test")
                    .resizable()
                    .scaledToFit()

                HStack {
                    Text(place.isOpen ? "Open" : "Closed")
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        
                        .foregroundColor(place.isOpen ? .green : .red)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(place.isOpen ? .green : .red, lineWidth: 1)
                        )

                    Spacer()

                    RatingStar(rating: String(format: "%.1f", place.rating))
                }
                .padding()
            }

            RestaurantInformationView(placeName: place.placeName, address: nil)
        }
        .cornerRadius(16)
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell(place: NearbyPlace(placeID: "place id", placeName: "Place name", isOpen: true, rating: 3.4))
            .background(.blue.opacity(0.2))
            .cornerRadius(16)
            .padding()
    }
}
