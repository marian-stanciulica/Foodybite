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
                        ForEach(0...50, id: \.self) { _ in
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

            HeaderView(
                name: "Category",
                allItemsCount: 9
            )

            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    ForEach(FoodCategory.allCases, id: \.self) { category in
                        HomeCategoryView(category: category)
                            .cornerRadius(16)
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .frame(maxHeight: 100)
            .padding()

            HeaderView(
                name: "Friends",
                allItemsCount: 56
            )

            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    ForEach(0...50, id: \.self) { index in
                        Image("profile_picture_test")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .cornerRadius(32)
                    }
                }
            }
            .frame(maxHeight: 64)
            .padding()
        }
        .background(.gray.opacity(0.1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
