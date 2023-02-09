//
//  RestaurantReviewCellView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import SwiftUI

struct RestaurantReviewCellView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image("restaurant_logo_test")
                    .resizable()
                    .scaledToFit()
                
                RatingStar(rating: "3", backgroundColor: .white)
                    .padding()
            }
            
            AddressView(placeName: "Place name", address: "Place address")
                .padding(.horizontal)
        }
        .cornerRadius(16)
    }
}

struct RestaurantReviewCellView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantReviewCellView()
    }
}
