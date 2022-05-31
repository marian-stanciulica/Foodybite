//
//  SelectCategoryView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct SelectCategoryView: View {
    @State var selectedCategory: Category = .italian
    
    private var threeColumnGrid = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: threeColumnGrid) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                if selectedCategory == category {
                    OrangeButton(title: category.rawValue.capitalized) {
                        selectedCategory = category
                    }
                } else {
                    WhiteButton(title: category.rawValue.capitalized) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct SelectCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCategoryView()
    }
}
