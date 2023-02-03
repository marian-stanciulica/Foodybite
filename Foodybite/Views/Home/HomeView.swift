//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import DomainModels
import SwiftUI

struct HomeView<Cell: View>: View {
    @StateObject var viewModel: HomeViewModel
    let showPlaceDetails: (String) -> Void
    let cell: (NearbyPlace) -> Cell

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.nearbyPlaces, id: \.placeID) { place in
                    cell(place)
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
            await viewModel.searchNearby()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(searchNearbyService: PreviewSearchNearbyService()), showPlaceDetails: { _ in }, cell: { nearbyPlace in
            RestaurantCell(viewModel: RestaurantCellViewModel(nearbyPlace: nearbyPlace, fetchPhotoService: PreviewFetchPlacePhotoService()))
        })
    }
    
    private class PreviewSearchNearbyService: SearchNearbyService {
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
            [
                NearbyPlace(placeID: "#1", placeName: "Place name #1", isOpen: true, rating: 3.4, location: Location(latitude: 0, longitude: 0), photo: nil),
                NearbyPlace(placeID: "#2", placeName: "Place name #2", isOpen: false, rating: 4.3, location: Location(latitude: 2, longitude: 1), photo: nil),
                NearbyPlace(placeID: "#3", placeName: "Place name #3", isOpen: true, rating: 5.0, location: Location(latitude: 4, longitude: 5), photo: nil)
            ]
        }
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            Data()
        }
    }
}
