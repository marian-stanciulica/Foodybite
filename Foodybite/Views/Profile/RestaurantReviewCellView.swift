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
    let showPlaceDetails: (PlaceDetails) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.getPlaceDetailsState {
            case .idle:
                EmptyView()
            case .isLoading:
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .frame(height: 200)
                    
                    ProgressView()
                }
            case let .failure(error):
                Text(error.rawValue)
                    .foregroundColor(.red)
                    .frame(height: 200)
                    .padding(.horizontal)
                    .background(Color(uiColor: .systemGray5))
            case let .success(placeDetails):
                ZStack(alignment: .topTrailing) {
                    switch viewModel.fetchPhotoState {
                    case .idle:
                        EmptyView()
                    case .isLoading:
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color(uiColor: .systemGray3))
                                .frame(height: 200)
                            
                            ProgressView()
                        }
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color(uiColor: .systemGray3))
                                .frame(height: 200)
                            
                            Image(systemName: "arrow.clockwise.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    Task {
                                        if let firstPhoto = placeDetails.photos.first {
                                            await viewModel.fetchPhoto(firstPhoto)
                                        }
                                    }
                                }
                        }
                    case let .success(photoData):
                        if let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    RatingStar(rating: viewModel.rating, backgroundColor: Color(uiColor: .systemGray6))
                        .padding()
                }
                
                AddressView(placeName: viewModel.placeName,
                            address: viewModel.placeAddress)
                .padding(.horizontal)
            }
        }
        .cornerRadius(16)
        .task {
            await viewModel.getPlaceDetails()
        }
        .onTapGesture {
            if case let .success(placeDetails) = viewModel.getPlaceDetailsState {
                showPlaceDetails(placeDetails)
            }
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
            ),
            showPlaceDetails: { _ in }
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
