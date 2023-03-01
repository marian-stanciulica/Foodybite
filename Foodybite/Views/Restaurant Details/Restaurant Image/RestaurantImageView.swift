//
//  RestaurantImageView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import Domain

struct RestaurantImageView: View {
    let photoView: PhotoView
    let phoneNumber: String?
    let showMaps: () -> Void

    var body: some View {
        ZStack {
            photoView

            VStack {
                Spacer()
                PhoneAndDirectionsView(phoneNumber: phoneNumber, showMaps: showMaps)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
        }
    }
}

struct RestaurantImageView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantImageView(
            photoView: PhotoView(
                viewModel: PhotoViewModel(
                    photoReference: "reference",
                    fetchPhotoService: PreviewFetchPlacePhotoService()
                )
            ),
            phoneNumber: "+61 2 9374 4000",
            showMaps: {}
        )
        .background(.black)
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")!.pngData()!
        }
    }
}
