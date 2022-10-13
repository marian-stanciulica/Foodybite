//
//  RestaurantPhotosView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantPhotosView: View {
    let imageWidth: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(name: "Photos", allItemsCount: 25)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(0...50, id: \.self) { _ in
                        Image("restaurant_logo_test")
                            .resizable()
                            .cornerRadius(16)
                            .frame(width: imageWidth, height: imageWidth * 0.8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RestaurantPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPhotosView(imageWidth: 150)
    }
}
