//
//  DistanceText.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct DistanceText: View {
    let distance: String

    var body: some View {
        Text(distance + " km")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .background(
                Capsule()
                    .foregroundColor(.marineBlue.opacity(0.75))
            )
            .font(.caption)
    }
}

struct DistanceText_Previews: PreviewProvider {
    static var previews: some View {
        DistanceText(distance: "1.2")
    }
}
