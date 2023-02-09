//
//  RestaurantDetailsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import DomainModels

struct RestaurantDetailsView: View {
    @StateObject var viewModel: RestaurantDetailsViewModel
    let showReviewView: () -> Void
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                ScrollView {
                    if let placeDetails = viewModel.placeDetails {
                        VStack(alignment: .leading) {
                            RestaurantImageView(phoneNumber: placeDetails.phoneNumber,
                                                showMaps: viewModel.showMaps,
                                                imageData: $viewModel.imageData)
                            
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
                                fetchPhoto: viewModel.fetchPhoto(at:),
                                photosData: $viewModel.photosData
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
                }
                
                MarineButton(title: "Rate Your Experience", action: showReviewView)
                    .padding(.horizontal)
            }
        }
        .task {
            if viewModel.placeDetails == nil {
                await viewModel.getPlaceDetails()
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
                    placeID: "#1",
                    currentLocation: Location(latitude: 1.2, longitude: 3.4),
                    getPlaceDetailsService: PreviewSearchNearbyService(),
                    fetchPhotoService: PreviewFetchPlacePhotoService(),
                    getReviewsService: PreviewGetReviewsService()
                ),
                showReviewView: {}
            )
        }
    }
    
    private class PreviewSearchNearbyService: GetPlaceDetailsService {
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            PlaceDetails(
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
                        profileImageURL: URL(string: "www.google.com"),
                        profileImageData: nil,
                        authorName: "Marian",
                        reviewText: "Loren ipsum...",
                        rating: 2,
                        relativeTime: "5 months ago"
                    ),
                    Review(
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
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            throw NSError(domain: "any error", code: 1)
        }
    }
    
    private class PreviewGetReviewsService: GetReviewsService {
        func getReviews(placeID: String?) async throws -> [Review] {
            []
        }
    }
}
