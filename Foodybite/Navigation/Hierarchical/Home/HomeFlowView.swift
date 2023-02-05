//
//  HomeFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import SwiftUI
import DomainModels
import FoodybiteNetworking
import FoodybitePlaces

struct HomeFlowView: View {
    @ObservedObject var flow: Flow<HomeRoute>
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    let currentLocation: Location
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            HomeView(viewModel: HomeViewModel(searchNearbyService: placesService, currentLocation: currentLocation), showPlaceDetails: { placeID in
                flow.append(.placeDetails(placeID))
            }, cell: { nearbyPlace in
                RestaurantCell(viewModel: RestaurantCellViewModel(nearbyPlace: nearbyPlace, fetchPhotoService: placesService, currentLocation: currentLocation))
            })
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .placeDetails(placeID):
                    RestaurantDetailsView(
                        viewModel: RestaurantDetailsViewModel(
                            placeID: placeID,
                            currentLocation: currentLocation,
                            getPlaceDetailsService: placesService,
                            fetchPhotoService: placesService,
                            getReviewsService: apiService
                        )) {
                            flow.append(.addReview(placeID))
                        }
                case let .addReview(placeID):
                    ReviewView(viewModel: ReviewViewModel(placeID: placeID, reviewService: apiService)) {
                        flow.navigateBack()
                    }
                }
            }
        }
    }
}
