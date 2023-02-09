//
//  OpenHoursView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import Domain
import SwiftUI

struct OpenHoursView: View {
    let openingHoursDetails: OpeningHoursDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(openingHoursDetails.openNow ? "Open Now" : "Closed")
                    .font(.callout)

                Spacer()

                Menu(openingHoursDetails.weekdayText.first ?? "") {
                    ForEach(openingHoursDetails.weekdayText, id: \.self) {
                        Text($0)
                    }
                }

                Image(systemName: "arrow.down")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            .foregroundColor(openingHoursDetails.openNow ? .green : .red)
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
            
            Spacer()
        }
    }
}
