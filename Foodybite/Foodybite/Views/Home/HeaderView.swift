//
//  HeaderView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct HeaderView: View {
    let name: String
    let allItemsCount: Int

    var body: some View {
        HStack {
            Text(name)
                .font(.title)
            Spacer()
            Text("See all (\(allItemsCount))")
                .foregroundColor(.gray)
                .font(.body)
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(name: "Trending Restaurants",
                   allItemsCount: 45)
    }
}
