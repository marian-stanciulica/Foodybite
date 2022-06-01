//
//  RestaurantInformationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct RestaurantInformationView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Happy Bones")
                    .font(.headline.weight(.bold))

                CategoryText()

                DistanceText(distance: 1.2)

                Spacer()

                Image("profile_picture_test")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .cornerRadius(12)
            }

            Text("394 Broome St, New York, NY 10013, USA")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct RestaurantInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantInformationView()
    }
}
