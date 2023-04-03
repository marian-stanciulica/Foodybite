//
//  HomeViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Domain
import FoodybitePresentation

final class HomeViewModelTests: XCTestCase {
    
    func test_init_searchText() {
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.searchText.isEmpty)
    }
    
    func test_init_searchNearbyState() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.searchNearbyState, .idle)
    }
    
    func test_searchNearby_sendsInputToNearbyRestaurantsService() async {
        let (sut, serviceSpy) = makeSUT()

        await sut.searchNearby()
        
        XCTAssertEqual(serviceSpy.capturedValues.count, 1)
        XCTAssertEqual(serviceSpy.capturedValues[0].location, anyLocation)
        XCTAssertEqual(serviceSpy.capturedValues[0].radius, anyUserPreferences.radius)
    }
    
    func test_searchNearby_setsErrorWhenNearbyRestaurantsServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        serviceSpy.result = .failure(anyError)
        
        await assert(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_searchNearby_updatesNearbyRestaurantsWhenNearbyRestaurantsServiceReturnsSuccessfully() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        serviceSpy.result = .success(expectedNearbyRestaurants)
        
        await assert(on: sut, withExpectedResult: .success(expectedNearbyRestaurants))
    }
    
    func test_filteredNearbyRestaurants_isEmptyWhenSearchNearbyStateIsNotSuccess() {
        let (sut, _) = makeSUT()
        
        sut.searchNearbyState = .idle
        XCTAssertTrue(sut.filteredNearbyRestaurants.isEmpty)
        
        sut.searchNearbyState = .isLoading
        XCTAssertTrue(sut.filteredNearbyRestaurants.isEmpty)
        
        sut.searchNearbyState = .failure(.serverError)
        XCTAssertTrue(sut.filteredNearbyRestaurants.isEmpty)
    }
    
    func test_filteredNearbyRestaurants_filtersNearbyRestaurantsUsingSearchText() {
        let (sut, _) = makeSUT()
        let nearbyRestaurants = makeNearbyRestaurants()
        sut.searchNearbyState = .success(nearbyRestaurants)
        sut.searchText = nearbyRestaurants[1].name
        
        XCTAssertEqual(sut.filteredNearbyRestaurants, [nearbyRestaurants[1]])
    }
    
    func test_filteredNearbyRestaurants_equalsNearbyRestaurantsWhenSearchTextIsEmpty() {
        let (sut, _) = makeSUT()
        let nearbyRestaurants = makeNearbyRestaurants()
        sut.searchNearbyState = .success(nearbyRestaurants)
        sut.searchText = ""
        
        XCTAssertEqual(sut.filteredNearbyRestaurants, nearbyRestaurants)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: HomeViewModel, serviceSpy: NearbyRestaurantsServiceSpy) {
        let serviceSpy = NearbyRestaurantsServiceSpy()
        let sut = HomeViewModel(nearbyRestaurantsService: serviceSpy, currentLocation: anyLocation, userPreferences: anyUserPreferences)
        return (sut, serviceSpy)
    }
    
    private func assert(on sut: HomeViewModel,
                        withExpectedResult expectedResult: HomeViewModel.State,
                        file: StaticString = #file,
                        line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$searchNearbyState.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.idle], file: file, line: line)
        
        await sut.searchNearby()
        
        XCTAssertEqual(resultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
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
