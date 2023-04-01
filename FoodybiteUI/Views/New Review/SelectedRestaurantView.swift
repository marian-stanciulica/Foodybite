//
//  SelectedRestaurantView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 11.02.2023.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct SelectedRestaurantView: View {
    let photoView: PhotoView
    let placeDetails: PlaceDetails
    
    public init(photoView: PhotoView, placeDetails: PlaceDetails) {
        self.photoView = photoView
        self.placeDetails = placeDetails
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            photoView

            AddressView(
                placeName: placeDetails.name,
                address: placeDetails.address
            )
            .padding(.horizontal)
        }
        .cornerRadius(16)
        .padding()
    }
}

struct SelectedRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedRestaurantView(
            photoView: PhotoView(
                viewModel: PhotoViewModel(
                    photoReference: "reference",
                    fetchPhotoService: PreviewFetchPlacePhotoService()
                )
            ),
            placeDetails: PlaceDetails(
                placeID: "",
                phoneNumber: nil,
                name: "Place name",
                address: "Place address",
                rating: 0,
                openingHoursDetails: nil,
                reviews: [],
                location: Location(latitude: 0, longitude: 0),
                photos: []
            )
        )
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")?.pngData() ?? Data()
        }
    }
    
}