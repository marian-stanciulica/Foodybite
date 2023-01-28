//
//  OpenHoursRatingView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct OpenHoursRatingView: View {
    var body: some View {
        HStack {
            Text("Happy Bones")
                .font(.title2.weight(.bold))

            CategoryText()

            DistanceText(distance: 1.2)

            Spacer()

            RatingStar(rating: "N/A")
        }
    }
}

struct OpenHoursRatingView_Previews: PreviewProvider {
    static var previews: some View {
        OpenHoursRatingView()
    }
}
