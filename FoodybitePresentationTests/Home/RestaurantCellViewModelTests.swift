//
//  RestaurantCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import XCTest
import Domain
import FoodybitePresentation

final class RestaurantCellViewModelTests: XCTestCase {
    
    func test_rating_returnsFormattedRating() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let sut = makeSUT()

        XCTAssertEqual(sut.distance, "353.6")
    }
    
    func test_isOpen_equalsNearbyRestaurantIsOpen() {
        let sut = makeSUT()

        XCTAssertEqual(sut.isOpen, isOpen())
    }
    
    func test_placeName_equalsNearbyRestaurantName() {
        let sut = makeSUT()

        XCTAssertEqual(sut.restaurantName, anyRestaurantName())
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> RestaurantCellViewModel {
        let sut = RestaurantCellViewModel(
            nearbyRestaurant: NearbyRestaurant(
                restaurantID: UUID().uuidString,
                placeName: anyRestaurantName(),
                isOpen: isOpen(),
                rating: rating().raw,
                location: Location(latitude: 4.4, longitude: 6.9),
                photo: anyPhoto()
            ),
            distanceInKmFromCurrentLocation: 353.6
        )
        return sut
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
    private func isOpen() -> Bool {
        return true
    }
    
    private func anyRestaurantName() -> String {
        "Restaurant name"
    }
    
    private func anyPhoto() -> Photo {
        Photo(width: 100, height: 200, photoReference: "photo reference")
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private var anyLocation: Location {
        Location(latitude: 2.3, longitude: 4.5)
    }
    
}
