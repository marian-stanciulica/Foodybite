//
//  RestaurantCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import DomainModels
import SwiftUI

struct RestaurantCell: View {
    let viewModel: RestaurantCellViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                Image("restaurant_logo_test")
                    .resizable()
                    .scaledToFit()

                HStack {
                    Text(viewModel.isOpen ? "Open" : "Closed")
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        
                        .foregroundColor(viewModel.isOpen ? .green : .red)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(viewModel.isOpen ? .green : .red, lineWidth: 1)
                        )

                    Spacer()

                    RatingStar(rating: viewModel.rating, backgroundColor: .white)
                }
                .padding()
            }

            RestaurantInformationView(
                placeName: viewModel.placeName,
                distance: viewModel.distanceInKmFromCurrentLocation,
                address: nil
            )
        }
        .cornerRadius(16)
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell(
            viewModel: RestaurantCellViewModel(
                nearbyPlace: NearbyPlace(
                    placeID: "place id",
                    placeName: "Place name",
                    isOpen: true,
                    rating: 3.4,
                    location: Location(latitude: 0, longitude: 0),
                    photo: nil
                )
            )
        )
        .background(.blue.opacity(0.2))
        .cornerRadius(16)
        .padding()
    }
}
