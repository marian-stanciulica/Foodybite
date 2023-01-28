//
//  RestaurantInformationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import DomainModels
import SwiftUI

struct RestaurantInformationView: View {
    let placeName: String
    let address: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(placeName)
                    .font(.headline.weight(.bold))

                CategoryText()

                DistanceText(distance: 1.2)
            }

            if let address = address {
                Text(address)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct RestaurantInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantInformationView(placeName: "Place name", address: "394 Broome St, New York, NY 10013, USA")
    }
}
