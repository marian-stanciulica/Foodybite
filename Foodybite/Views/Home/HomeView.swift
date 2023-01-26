//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(0...50, id: \.self) { _ in
                        RestaurantCell()
                            .background(.white)
                            .cornerRadius(16)
                            .frame(width: proxy.size.width)
                            .aspectRatio(0.75, contentMode: .fit)
                            .padding(4)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
