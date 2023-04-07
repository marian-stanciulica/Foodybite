//
//  StatsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct StatsView: View {
    let stats: String
    let description: String

    var body: some View {
        VStack {
            Text(stats)
                .foregroundColor(.marineBlue)
                .font(.title2)

            Text(description)
                .foregroundColor(.gray)
                .font(.body)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(stats: "100k", description: "Reviews")
    }
}
