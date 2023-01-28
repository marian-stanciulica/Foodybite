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
                        RestaurantImageView(phoneNumber: placeDetails.phoneNumber)
                        
                        HStack {
                            RestaurantInformationView(
                                placeName: placeDetails.name,
                                address: placeDetails.address
                            )
                            
                            Spacer()
                            
                            RatingStar(rating: viewModel.rating)
                                .padding(4)
                        }
                        
                        OpenHoursView(openingHoursDetails: placeDetails.openingHoursDetails)
                            .padding(.horizontal)
                        
                        RestaurantPhotosView(imageWidth: proxy.size.width / 2.5)
                            .padding(.bottom)
                        
                        HeaderView(name: "Review & Ratings", allItemsCount: 32)
                        
                        LazyVStack {
                            ForEach(0...50, id: \.self) { _ in
                                ReviewCell()
                                    .padding(.horizontal)
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
                name: "Place name",
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
                )
            )
        }
    }
}
