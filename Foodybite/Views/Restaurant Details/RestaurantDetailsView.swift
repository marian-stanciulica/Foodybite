//
//  RestaurantDetailsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import DomainModels

struct RestaurantDetailsView: View {
    @ObservedObject var viewModel: RestaurantDetailsViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    RestaurantImageView()

                    OpenHoursView()
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
            PlaceDetails(phoneNumber: "+61 2 9374 4000", name: "Place name", address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia", rating: 4.5)
        }
    }
}
