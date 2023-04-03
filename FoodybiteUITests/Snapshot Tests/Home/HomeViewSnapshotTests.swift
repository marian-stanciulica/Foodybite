//
//  HomeViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class HomeViewSnapshotTests: XCTestCase {
    
    func test_homeViewIdleState() {
        let sut = makeSUT(getNearbyPlacesState: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewLoadingState() {
        let sut = makeSUT(getNearbyPlacesState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewFailureState() {
        let sut = makeSUT(getNearbyPlacesState: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewSuccessState() {
        let sut = makeSUT(getNearbyPlacesState: .success(makeNearbyRestaurants()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewWhenGetNearbyPlaceStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(getNearbyPlacesState: .success(makeNearbyRestaurants()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewWhenGetNearbyPlaceStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getNearbyPlacesState: .success(makeNearbyRestaurants()),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewWhenSearchTextIsNotEmpty() {
        let nearbyRestaurants = makeNearbyRestaurants()
        let sut = makeSUT(searchText: nearbyRestaurants[1].placeName,
                          getNearbyPlacesState: .success(nearbyRestaurants),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(searchText: String = "", getNearbyPlacesState: HomeViewModel.State, fetchPhotoState: PhotoViewModel.State = .isLoading) -> HomeView<RestaurantCell, HomeSearchView<SearchCriteriaView>> {
        let currentLocation = Location(latitude: 0, longitude: 0)
        
        let homeViewModel = HomeViewModel(nearbyRestaurantsService: EmptyNearbyRestaurantsService(),
                                          currentLocation: currentLocation,
                                          userPreferences: UserPreferences(radius: 200, starsNumber: 4))
        homeViewModel.searchNearbyState = getNearbyPlacesState
        homeViewModel.searchText = searchText
        
        let photoViewModel = PhotoViewModel(
            photoReference: "reference",
            restaurantPhotoService: EmptyPlacePhotoService()
        )
        photoViewModel.fetchPhotoState = fetchPhotoState
        
        let searchCriteriaViewModel = SearchCriteriaViewModel(
            userPreferences: makeUserPreferences(),
            userPreferencesSaver: EmptyUserPreferencesSaver()
        )
        
        let homeView = HomeView(
            viewModel: homeViewModel,
            showPlaceDetails: { _ in },
            cell: { nearbyRestaurant in
                RestaurantCell(
                    photoView: PhotoView(viewModel: photoViewModel),
                    viewModel: RestaurantCellViewModel(
                        nearbyRestaurant: nearbyRestaurant,
                        distanceInKmFromCurrentLocation: 23.4
                    )
                )
            },
            searchView: { searchText in
                HomeSearchView(
                    searchText: searchText,
                    searchCriteriaView: SearchCriteriaView(viewModel: searchCriteriaViewModel)
                )
            }
        )

        return homeView
    }
    
    private func makeNearbyRestaurants() -> [NearbyRestaurant] {
        [
            NearbyRestaurant(
                placeID: "place #1",
                placeName: "Place name 1",
                isOpen: true,
                rating: 3,
                location: Location(latitude: 2, longitude: 5),
                photo: nil),
            NearbyRestaurant(
                placeID: "place #2",
                placeName: "Place name 2",
                isOpen: false,
                rating: 4,
                location: Location(latitude: 43, longitude: 56),
                photo: nil),
            NearbyRestaurant(
                placeID: "place #3",
                placeName: "Place name 3",
                isOpen: true,
                rating: 5,
                location: Location(latitude: 3, longitude: 6),
                photo: nil)
        ]
    }
    
    private class EmptyNearbyRestaurantsService: NearbyRestaurantsService {
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] { [] }
    }
            
    private func makeUserPreferences() -> UserPreferences {
        UserPreferences(radius: 200, starsNumber: 4)
    }
    
    private class EmptyUserPreferencesSaver: UserPreferencesSaver {
        func save(_ userPreferences: UserPreferences) {}
    }
}
 
