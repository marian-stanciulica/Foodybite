//
//  RestaurantPhotosView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantPhotosView: View {
    let imageWidth: CGFloat
    let photosReferences: [String?]
    let makePhotoView: (String?) -> PhotoView

    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(name: "Photos", allItemsCount: photosReferences.count)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(photosReferences, id: \.self) {
                        makePhotoView($0)
                            .frame(width: imageWidth, height: imageWidth * 0.8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
