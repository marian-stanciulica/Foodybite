//
//  RestaurantDetailsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct RestaurantDetailsView: View {
    @ObservedObject var viewModel: RestaurantDetailsViewModel
    let makePhotoView: (String?) -> PhotoView
    let showReviewView: () -> Void
    
    public init(viewModel: RestaurantDetailsViewModel, makePhotoView: @escaping (String?) -> PhotoView, showReviewView: @escaping () -> Void) {
        self.viewModel = viewModel
        self.makePhotoView = makePhotoView
        self.showReviewView = showReviewView
    }
    
    public var body: some View {
        VStack {
            switch viewModel.getPlaceDetailsState {
            case .idle:
                EmptyView()
                
            case .isLoading:
                ProgressView()
                Spacer()
                
            case let .failure(error):
                Text(error.rawValue)
                    .foregroundColor(.red)
                
                Spacer()
                
            case let .success(placeDetails):
                GeometryReader { proxy in
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            VStack(alignment: .leading) {
                                RestaurantImageView(
                                    photoView: makePhotoView(placeDetails.photos.first?.photoReference),
                                    phoneNumber: placeDetails.phoneNumber,
                                    showMaps: viewModel.showMaps)
                                
                                HStack {
                                    RestaurantInformationView(
                                        placeName: placeDetails.name,
                                        distance: viewModel.distanceInKmFromCurrentLocation,
                                        address: placeDetails.address
                                    )
                                    
                                    Spacer()
                                    
                                    RatingStar(
                                        rating: viewModel.rating,
                                        backgroundColor: .gray.opacity(0.1)
                                    )
                                    .padding(4)
                                }
                                .padding(.horizontal)
                                
                                if let openingHoursDetails = placeDetails.openingHoursDetails {
                                    OpenHoursView(openingHoursDetails: openingHoursDetails)
                                        .padding(.horizontal)
                                }
                                
                                RestaurantPhotosView(
                                    imageWidth: proxy.size.width / 2.5,
                                    photosReferences: placeDetails.photos.map { $0.photoReference },
                                    makePhotoView: makePhotoView
                                )
                                .padding(.bottom)
                                
                                HeaderView(name: "Review & Ratings", allItemsCount: placeDetails.reviews.count)
                                
                                LazyVStack {
                                    ForEach(placeDetails.reviews) { review in
                                        ReviewCell(review: review)
                                    }
                                }
                            }
                        }
                        
                        MarineButton(title: "Rate Your Experience", isLoading: false, action: showReviewView)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .task {
            if viewModel.getPlaceDetailsState == .idle {
                await viewModel.getRestaurantDetails()
            }
            
            await viewModel.getPlaceReviews()
        }
        .arrowBackButtonStyle()
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView(
                viewModel: RestaurantDetailsViewModel(
                    input: .placeIdToFetch("#1"),
                    getDistanceInKmFromCurrentLocation: { _ in 3.4 },
                    restaurantDetailsService: PreviewNearbyRestaurantsService(),
                    getReviewsService: PreviewGetReviewsService()
                ),
                makePhotoView: { _ in
                    PhotoView(
                        viewModel: PhotoViewModel(
                            photoReference: "reference",
                            restaurantPhotoService: PreviewFetchPlacePhotoService()
                        )
                    )
                },
                showReviewView: {}
            )
        }
    }
    
    private class PreviewNearbyRestaurantsService: RestaurantDetailsService {
        func getRestaurantDetails(placeID: String) async throws -> RestaurantDetails {
            RestaurantDetails(
                placeID: "place #1",
                phoneNumber: "+61 2 9374 4000",
                name: "Happy Bones",
                address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
                rating: 4.5,
                openingHoursDetails: OpeningHoursDetails(
                    openNow: true,
                    weekdayText: [
                        "Monday: 9:00 AM – 5:00 PM",
                        "Tuesday: 9:00 AM – 5:00 PM",
                        "Wednesday: 9:00 AM – 5:00 PM",
                        "Thursday: 9:00 AM – 5:00 PM",
                        "Friday: 9:00 AM – 5:00 PM",
                        "Saturday: Closed",
                        "Sunday: Closed",
                    ]
                ),
                reviews: [
                    Review(
                        placeID: "place #1",
                        profileImageURL: URL(string: "www.google.com"),
                        profileImageData: nil,
                        authorName: "Marian",
                        reviewText: "Loren ipsum...",
                        rating: 2,
                        relativeTime: "5 months ago"
                    ),
                    Review(
                        placeID: "place #1",
                        profileImageURL: URL(string: "www.google.com"),
                        profileImageData: nil,
                        authorName: "Marian",
                        reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sit amet dapibus justo, eu cursus nulla. Nulla viverra mollis ante et rutrum. Mauris lorem ante, congue eget malesuada quis, hendrerit vel elit. Suspendisse potenti. Phasellus molestie vehicula blandit. Fusce sit amet egestas augue. Integer quis lacinia massa. Aliquam hendrerit arcu eget leo congue maximus. Etiam interdum eget mi at consectetur. ",
                        rating: 4,
                        relativeTime: "1 day ago"
                    )
                ],
                location: Location(latitude: 44.439663, longitude: 26.096306),
                photos: [Photo(width: 100, height: 100, photoReference: "ceva")]
            )
        }
    }
    
    private class PreviewFetchPlacePhotoService: RestaurantPhotoService {
        func fetchPhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")!.pngData()!
        }
    }
    
    private class PreviewGetReviewsService: GetReviewsService {
        func getReviews(placeID: String?) async throws -> [Review] {
            []
        }
    }
}
