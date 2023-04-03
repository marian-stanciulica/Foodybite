//
//  HomeView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Domain
import SwiftUI
import FoodybitePresentation

public struct HomeView<Cell: View, SearchView: View>: View {
    @ObservedObject var viewModel: HomeViewModel
    let showPlaceDetails: (String) -> Void
    let cell: (NearbyRestaurant) -> Cell
    let searchView: (Binding<String>) -> SearchView
    
    public init(
        viewModel: HomeViewModel,
        showPlaceDetails: @escaping (String) -> Void,
        cell: @escaping (NearbyRestaurant) -> Cell,
        searchView: @escaping (Binding<String>) -> SearchView
    ) {
        self.viewModel = viewModel
        self.showPlaceDetails = showPlaceDetails
        self.cell = cell
        self.searchView = searchView
    }
    
    public var body: some View {
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
                
            case .success:
                ScrollView(.vertical, showsIndicators: false) {
                    searchView($viewModel.searchText)
                        .padding(.bottom)
                    
                    LazyVStack {
                        ForEach(viewModel.filteredNearbyRestaurants, id: \.placeID) { place in
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
            guard viewModel.searchNearbyState == .idle else { return }
            
            await viewModel.searchNearby()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel(
                searchNearbyService: PreviewSearchNearbyService(),
                currentLocation: Location(latitude: 2.3, longitude: 4.5),
                userPreferences: UserPreferences(radius: 200, starsNumber: 4)
            ),
            showPlaceDetails: { _ in }, cell: { nearbyRestaurant in
                RestaurantCell(
                    photoView: PhotoView(
                        viewModel: PhotoViewModel(
                            photoReference: "reference",
                            fetchPhotoService: PreviewFetchPlacePhotoService()
                        )
                    ),
                    viewModel: RestaurantCellViewModel(
                        nearbyRestaurant: nearbyRestaurant,
                        distanceInKmFromCurrentLocation: 2.3
                    )
                )
            },
                 searchView: { _ in EmptyView() }
        )
    }
    
    private class PreviewSearchNearbyService: SearchNearbyService {
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
            [
                NearbyRestaurant(placeID: "#1", placeName: "Place name #1", isOpen: true, rating: 3.4, location: Location(latitude: 0, longitude: 0), photo: nil),
                NearbyRestaurant(placeID: "#2", placeName: "Place name #2", isOpen: false, rating: 4.3, location: Location(latitude: 2, longitude: 1), photo: nil),
                NearbyRestaurant(placeID: "#3", placeName: "Place name #3", isOpen: true, rating: 5.0, location: Location(latitude: 4, longitude: 5), photo: nil)
            ]
        }
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")!.pngData()!
        }
    }
}
