//
//  OpenHoursView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct OpenHoursView: View {
    var body: some View {
        VStack(alignment: .leading) {
            OpenHoursRatingView()

            Text("394 Broome St, New York, NY 10013, USA")
                .foregroundColor(.gray)
                .font(.callout)

            HStack {
                Text("Open Now ")
                    .foregroundColor(.green)
                    .font(.callout) +

                Text("daily time ")
                    .foregroundColor(.gray)
                    .font(.callout) +

                Text("9:30 am to 11:00 pm")
                    .foregroundColor(.red)
                    .font(.callout)

                Image(systemName: "arrow.down")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            .padding(.vertical, 2)
        }
    }
}

struct OpenHoursView_Previews: PreviewProvider {
    static var previews: some View {
        OpenHoursView()
    }
}
