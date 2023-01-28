//
//  HomeFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import SwiftUI
import FoodybitePlaces

struct HomeFlowView: View {
    @ObservedObject var flow: Flow<HomeRoute>
    let placesService: FoodybitePlaces.APIService
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            HomeView(viewModel: HomeViewModel(searchNearbyService: placesService), showPlaceDetails: { placeID in
                flow.append(.placeDetails(placeID))
            })
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .placeDetails:
                    RestaurantDetailsView()
                }
            }
        }
    }
}
