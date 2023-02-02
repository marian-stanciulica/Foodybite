//
//  RestaurantPhotosView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RestaurantPhotosView: View {
    let imageWidth: CGFloat
    let fetchPhoto: (Int) async -> Void
    @Binding var photosData: [Data?]

    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(name: "Photos", allItemsCount: 25)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(photosData.indices, id: \.self) { index in
                        if let photoData = photosData[index], let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .cornerRadius(16)
                                .frame(width: imageWidth, height: imageWidth * 0.8)
                        } else {
                            Image("restaurant_logo_test")
                                .resizable()
                                .cornerRadius(16)
                                .frame(width: imageWidth, height: imageWidth * 0.8)
                                .task {
                                    await fetchPhoto(index)
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RestaurantPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPhotosView(imageWidth: 150, fetchPhoto: { _ in }, photosData: .constant([]))
    }
}
