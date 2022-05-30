//
//  CategoriesListView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct CategoriesListView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HeaderView(
            name: "Category",
            allItemsCount: 9
        )

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    HomeCategoryView(category: category)
                        .cornerRadius(16)
                        .frame(
                            width: width,
                            height: height
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
        }
        .padding(.horizontal)
    }
}
