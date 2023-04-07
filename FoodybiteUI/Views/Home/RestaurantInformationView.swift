//
//  RestaurantInformationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Domain
import SwiftUI

struct RestaurantInformationView: View {
    let name: String
    let distance: String
    let address: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name)
                    .font(.title2.weight(.bold))

                DistanceText(distance: distance)
            }

            if let address = address {
                Text(address)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct RestaurantInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantInformationView(
            name: "Happy Bones",
            distance: "1.2",
            address: "394 Broome St, New York, NY 10013, USA"
        )
    }
}
