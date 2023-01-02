//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct HomeView: View {
    @State var searchText = ""
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
//                    SearchView(searchText: $searchText)
                    
                    TrendingRestaurantsView(widthCell: proxy.size.width - 64)

                    CategoriesListView(
                        width: proxy.size.width / 4,
                        height: proxy.size.width / 4
                    )

                    FriendsListView(
                        width: proxy.size.width / 8,
                        height: proxy.size.width / 8
                    )
                }
            }
            .background(.gray.opacity(0.1))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
