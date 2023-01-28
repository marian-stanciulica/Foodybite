//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import DomainModels
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    let showPlaceDetails: (String) -> Void

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.nearbyPlaces, id: \.placeID) { place in
                    RestaurantCell(place: place)
                        .background(.white)
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(0.75, contentMode: .fit)
                        .padding(4)
                        .shadow(color:.gray.opacity(0.2), radius: 2)
                        .onTapGesture {
                            showPlaceDetails(place.placeID)
                        }
                }
            }
        }
        .padding(.horizontal)
        .task {
            await viewModel.searchNearby(location: Location(latitude: -33.8670522, longitude: 151.1957362), radius: 100)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(searchNearbyService: PreviewSearchNearbyService()), showPlaceDetails: { _ in })
    }
    
    private class PreviewSearchNearbyService: SearchNearbyService {
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
            [
                NearbyPlace(placeID: "#1", placeName: "Place name #1", isOpen: true, rating: 3.4),
                NearbyPlace(placeID: "#2", placeName: "Place name #2", isOpen: false, rating: 4.3),
                NearbyPlace(placeID: "#3", placeName: "Place name #3", isOpen: true, rating: 5.0)
            ]
        }
    }
}
