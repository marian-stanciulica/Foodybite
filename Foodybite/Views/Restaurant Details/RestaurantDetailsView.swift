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
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                if let placeDetails = viewModel.placeDetails {
                    VStack(alignment: .leading) {
                        RestaurantImageView(phoneNumber: placeDetails.phoneNumber, showMaps: viewModel.showMaps)
                        
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
                        
                        RestaurantPhotosView(imageWidth: proxy.size.width / 2.5)
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
        }
        .task {
            await viewModel.getPlaceDetails()
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
                    getPlaceDetailsService: PreviewSearchNearbyService()
                )
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
                        profileImageURL: URL(string: "www.google.com")!,
                        authorName: "Marian",
                        reviewText: "Loren ipsum...",
                        rating: 2,
                        relativeTime: "5 months ago"
                    )
                ],
                location: Location(latitude: 44.439663, longitude: 26.096306)
            )
        }
    }
}
