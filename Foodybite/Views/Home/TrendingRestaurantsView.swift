//
//  TrendingRestaurantsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct TrendingRestaurantsView: View {
    let widthCell: CGFloat
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                ForEach(0...50, id: \.self) { _ in
                    RestaurantCell()
                        .background(.white)
                        .cornerRadius(16)
                        .frame(width: widthCell)
                        .aspectRatio(0.75, contentMode: .fit)
                        .padding(4)
                }
            }
        }
        .padding(.horizontal)
    }
}

