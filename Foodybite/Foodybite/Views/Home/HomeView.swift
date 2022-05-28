//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HeaderView(
                name: "Trending Restaurants",
                allItemsCount: 45
            )

            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top) {
                        ForEach(0...50, id: \.self) { index in
                            RestaurantCell()
                                .background(.white)
                                .cornerRadius(16)
                                .padding(4)
                                .frame(maxWidth: proxy.size.width - 24)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            .padding(8)
        }
        .background(.gray.opacity(0.1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
