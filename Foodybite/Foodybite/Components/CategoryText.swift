//
//  CategoryText.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct CategoryText: View {
    var body: some View {
        Text("Category")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .background(
                Capsule()
                    .foregroundColor(.orange.opacity(0.5))
            )
            .font(.caption)
    }
}

struct CategoryText_Previews: PreviewProvider {
    static var previews: some View {
        CategoryText()
    }
}
