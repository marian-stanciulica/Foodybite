//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Domain
import SwiftUI

struct HomeView<Cell: View, SearchView: View>: View {
    @StateObject var viewModel: HomeViewModel
    let showPlaceDetails: (String) -> Void
    let cell: (NearbyPlace) -> Cell
    let searchView: (Binding<String>) -> SearchView
    
    var body: some View {
        VStack {
            switch viewModel.searchNearbyState {
            case .idle:
                EmptyView()
                
            case .isLoading:
                ProgressView()
                Spacer()
                
            case let .failure(error):
                Text(error.rawValue)
                    .foregroundColor(.red)
                Spacer()
                
            case let .success(nearbyPlaces):
                ScrollView(.vertical, showsIndicators: false) {
                    searchView($viewModel.searchText)
                        .padding(.bottom)
                    
                    LazyVStack {
                        ForEach(nearbyPlaces, id: \.placeID) { place in
                            cell(place)
                                .background(Color(uiColor: .systemBackground))
                                .cornerRadius(16)
                                .frame(maxWidth: .infinity)
                                .aspectRatio(0.75, contentMode: .fit)
                                .padding(4)
                                .shadow(color: Color(uiColor: .systemGray3), radius: 2)
                                .onTapGesture {
                                    showPlaceDetails(place.placeID)
                                }
                        }
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
        HomeView(viewModel: HomeViewModel(searchNearbyService: PreviewSearchNearbyService(), currentLocation: Location(latitude: 2.3, longitude: 4.5)), showPlaceDetails: { _ in }, cell: { nearbyPlace in
                RestaurantCell(
                    photoView: PhotoView(
                        viewModel: PhotoViewModel(
                            photoReference: "reference",
                            fetchPhotoService: PreviewFetchPlacePhotoService()
                        )
                    ),
                    viewModel: RestaurantCellViewModel(
                        nearbyPlace: nearbyPlace,
                        currentLocation: Location(latitude: 2.1, longitude: 3.4)
                    )
                )
            },
                 searchView: { _ in EmptyView() }
        )
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
            UIImage(named: "restaurant_logo_test")!.pngData()!
        }
    }
}
