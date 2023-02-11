//
//  SelectedRestaurantView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 11.02.2023.
//

import SwiftUI
import Domain

struct SelectedRestaurantView: View {
    @StateObject var viewModel: SelectedRestaurantViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.fetchPhotoState {
            case .requestSucceeeded(let imageData):
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            default:
                Image("restaurant_logo_test")
                    .resizable()
                    .scaledToFit()
            }

            AddressView(
                placeName: viewModel.placeName,
                address: viewModel.placeAddress
            )
            .padding(.horizontal)
        }
        .cornerRadius(16)
        .padding()
        .task {
            await viewModel.fetchPhoto()
        }
    }
}

struct SelectedRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedRestaurantView(
            viewModel: SelectedRestaurantViewModel(
                placeDetails: PlaceDetails(
                    placeID: "place #1",
                    phoneNumber: nil,
                    name: "Place name",
                    address: "Place address",
                    rating: 0,
                    openingHoursDetails: nil,
                    reviews: [],
                    location: Location(latitude: 0, longitude: 0),
                    photos: [
                        Photo(width: 100, height: 100, photoReference: "")
                    ]
                ),
                fetchPlacePhotoService: PreviewFetchPlacePhotoService()
            )
        )
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")?.pngData() ?? Data()
        }
    }
    
}
