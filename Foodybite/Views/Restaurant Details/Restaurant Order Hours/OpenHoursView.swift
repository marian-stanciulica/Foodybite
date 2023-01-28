//
//  OpenHoursView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import DomainModels
import SwiftUI

struct OpenHoursView: View {
    let openingHoursDetails: OpeningHoursDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(openingHoursDetails.openNow ? "Open Now" : "Closed")
                    .font(.callout)

                Spacer()

                Text(openingHoursDetails.weekdayText.first ?? "")
                    .font(.callout)

                Image(systemName: "arrow.down")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            .foregroundColor(openingHoursDetails.openNow ? .green : .red)
            .padding()
        }
    }
}

struct OpenHoursView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OpenHoursView(
                openingHoursDetails: OpeningHoursDetails(
                    openNow: true,
                    weekdayText: [
                        "Monday: 9:00 AM – 5:00 PM",
                        "Tuesday: 9:00 AM – 5:00 PM",
                        "Wednesday: 9:00 AM – 5:00 PM",
                        "Thursday: 9:00 AM – 5:00 PM",
                        "Friday: 9:00 AM – 5:00 PM",
                        "Saturday: Closed",
                        "Sunday: Closed",
                    ]
                )
            )
            
            OpenHoursView(
                openingHoursDetails: OpeningHoursDetails(
                    openNow: false,
                    weekdayText: [
                        "Monday: 9:00 AM – 5:00 PM",
                        "Tuesday: 9:00 AM – 5:00 PM",
                        "Wednesday: 9:00 AM – 5:00 PM",
                        "Thursday: 9:00 AM – 5:00 PM",
                        "Friday: 9:00 AM – 5:00 PM",
                        "Saturday: Closed",
                        "Sunday: Closed",
                    ]
                )
            )
        }
    }
}
