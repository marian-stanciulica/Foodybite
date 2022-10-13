//
//  HomeCategoryView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

enum FoodCategory: String, CaseIterable {
    case american
    case chinese
    case indian
    case italian
    case korean
    case mexican
    case thai
}

struct HomeCategoryView: View {
    let category: FoodCategory

    var body: some View {
        ZStack {
            Image("restaurant_logo_test")
                .resizable()

            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.pink.opacity(0.5))

            Text(category.rawValue.capitalized)
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
        }
        .clipped()
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct HomeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCategoryView(category: .italian)
    }
}
