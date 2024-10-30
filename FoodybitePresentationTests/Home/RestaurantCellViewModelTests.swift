//
//  RestaurantCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import Testing
import Foundation.NSUUID
import Domain
import FoodybitePresentation

struct RestaurantCellViewModelTests {

    @Test func rating_returnsFormattedRating() {
        let sut = makeSUT()

        #expect(sut.rating == rating().formatted)
    }

    @Test func distanceInKmFromCurrentLocation_computedCorrectly() {
        let sut = makeSUT()

        #expect(sut.distance == "353.6")
    }

    @Test func isOpen_equalsNearbyRestaurantIsOpen() {
        let sut = makeSUT()

        #expect(sut.isOpen == isOpen())
    }

    @Test func restaurantName_equalsNearbyRestaurantName() {
        let sut = makeSUT()

        #expect(sut.restaurantName == anyRestaurantName())
    }

    // MARK: - Helpers

    private func makeSUT() -> RestaurantCellViewModel {
        let sut = RestaurantCellViewModel(
            nearbyRestaurant: NearbyRestaurant(
                id: UUID().uuidString,
                name: anyRestaurantName(),
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
