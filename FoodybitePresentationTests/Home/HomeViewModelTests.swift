//
//  HomeViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Testing
import Foundation.NSError
import Domain
import FoodybitePresentation

struct HomeViewModelTests {

    @Test func init_searchText() {
        let (sut, _) = makeSUT()

        #expect(sut.searchText.isEmpty == true)
    }

    @Test func init_searchNearbyState() {
        let (sut, _) = makeSUT()

        #expect(sut.searchNearbyState == .idle)
    }

    @Test func searchNearby_sendsInputToNearbyRestaurantsService() async {
        let (sut, serviceSpy) = makeSUT()

        await sut.searchNearby()

        #expect(serviceSpy.capturedValues.count == 1)
        #expect(serviceSpy.capturedValues[0].location == anyLocation)
        #expect(serviceSpy.capturedValues[0].radius == anyUserPreferences.radius)
    }

    @Test func searchNearby_setsErrorWhenNearbyRestaurantsServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        serviceSpy.result = .failure(anyError)

        await assert(on: sut, withExpectedResult: .failure(.serverError))
    }

    @Test func searchNearby_updatesNearbyRestaurantsWhenNearbyRestaurantsServiceReturnsSuccessfully() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        serviceSpy.result = .success(expectedNearbyRestaurants)

        await assert(on: sut, withExpectedResult: .success(expectedNearbyRestaurants))
    }

    @Test func filteredNearbyRestaurants_isEmptyWhenSearchNearbyStateIsNotSuccess() {
        let (sut, _) = makeSUT()

        sut.searchNearbyState = .idle
        #expect(sut.filteredNearbyRestaurants.isEmpty == true)

        sut.searchNearbyState = .isLoading
        #expect(sut.filteredNearbyRestaurants.isEmpty == true)

        sut.searchNearbyState = .failure(.serverError)
        #expect(sut.filteredNearbyRestaurants.isEmpty == true)
    }

    @Test func filteredNearbyRestaurants_filtersNearbyRestaurantsUsingSearchText() {
        let (sut, _) = makeSUT()
        let nearbyRestaurants = makeNearbyRestaurants()
        sut.searchNearbyState = .success(nearbyRestaurants)
        sut.searchText = nearbyRestaurants[1].name

        #expect(sut.filteredNearbyRestaurants == [nearbyRestaurants[1]])
    }

    @Test func filteredNearbyRestaurants_equalsNearbyRestaurantsWhenSearchTextIsEmpty() {
        let (sut, _) = makeSUT()
        let nearbyRestaurants = makeNearbyRestaurants()
        sut.searchNearbyState = .success(nearbyRestaurants)
        sut.searchText = ""

        #expect(sut.filteredNearbyRestaurants == nearbyRestaurants)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HomeViewModel, serviceSpy: NearbyRestaurantsServiceSpy) {
        let serviceSpy = NearbyRestaurantsServiceSpy()
        let sut = HomeViewModel(nearbyRestaurantsService: serviceSpy, currentLocation: anyLocation, userPreferences: anyUserPreferences)
        return (sut, serviceSpy)
    }

    private func assert(on sut: HomeViewModel,
                        withExpectedResult expectedResult: HomeViewModel.State,
                        sourceLocation: SourceLocation = #_sourceLocation) async {
        let resultSpy = PublisherSpy(sut.$searchNearbyState.eraseToAnyPublisher())

        #expect(resultSpy.results == [.idle], sourceLocation: sourceLocation)

        await sut.searchNearby()

        #expect(resultSpy.results == [.idle, .isLoading, expectedResult], sourceLocation: sourceLocation)
        resultSpy.cancel()
    }

    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }

    private var anyLocation: Location {
        Location(latitude: 2.3, longitude: 4.5)
    }

    private var anyUserPreferences: UserPreferences {
        UserPreferences(radius: 200, starsNumber: 4)
    }

    private func makeNearbyRestaurants() -> [NearbyRestaurant] {
        [
            NearbyRestaurant(id: "#1", name: "restaurant 1", isOpen: false, rating: 2.3, location: Location(latitude: 0, longitude: 1), photo: nil),
            NearbyRestaurant(id: "#2", name: "restaurant 2", isOpen: true, rating: 4.4, location: Location(latitude: 2, longitude: 3), photo: nil),
            NearbyRestaurant(id: "#3", name: "restaurant 3", isOpen: false, rating: 4.5, location: Location(latitude: 4, longitude: 5), photo: nil)
        ]
    }

    private class NearbyRestaurantsServiceSpy: NearbyRestaurantsService {
        var result: Result<[NearbyRestaurant], Error>?
        private(set) var capturedValues = [(location: Location, radius: Int)]()

        func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
            capturedValues.append((location, radius))

            if let result = result {
                return try result.get()
            }

            return []
        }
    }

}
