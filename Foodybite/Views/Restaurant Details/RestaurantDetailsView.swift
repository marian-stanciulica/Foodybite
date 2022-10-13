//
//  RestaurantDetailsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantDetailsView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    RestaurantImageView()

                    OpenHoursView()
                        .padding(.horizontal)

                    RestaurantPhotosView(imageWidth: proxy.size.width / 2.5)
                        .padding(.bottom)

                    HeaderView(name: "Review & Ratings", allItemsCount: 32)

                    LazyVStack {
                        ForEach(0...50, id: \.self) { _ in
                            ReviewCell()
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsView()
    }
}
