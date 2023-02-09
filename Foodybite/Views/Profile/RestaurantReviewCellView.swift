//
//  RestaurantReviewCellView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import SwiftUI
import Domain

struct RestaurantReviewCellView: View {
    @StateObject var viewModel: RestaurantReviewCellViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                switch viewModel.fetchPhotoState {
                case .isLoading, .loadingError:
                    ProgressView()
                case let .requestSucceeeded(photoData):
                    if let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                RatingStar(rating: viewModel.rating, backgroundColor: .white)
                    .padding()
            }
            
            AddressView(placeName: viewModel.placeName,
                        address: viewModel.placeAddress)
                .padding(.horizontal)
        }
        .cornerRadius(16)
        .task {
            await viewModel.getPlaceDetails()
        }
    }
}

struct RestaurantReviewCellView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantReviewCellView(
            viewModel: RestaurantReviewCellViewModel(
                review: Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Marian", reviewText: "nice", rating: 2, relativeTime: "10 hours ago"),
                getPlaceDetailsService: PreviewGetPlaceDetailsService(),
                fetchPlacePhotoService: PreviewFetchPlacePhotoService()
            )
        )
    }
    
    private class PreviewGetPlaceDetailsService: GetPlaceDetailsService {
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            PlaceDetails(
                placeID: "place #1",
                phoneNumber: "",
                name: "Place name",
                address: "Place address",
                rating: 3,
                openingHoursDetails: nil,
                reviews: [],
                location: Location(latitude: 0, longitude: 0),
                photos: [
                    Photo(width: 100, height: 100, photoReference: "")
                ]
            )
        }
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")?.pngData() ?? Data()
        }
    }
}
