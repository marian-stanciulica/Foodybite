//
//  RestaurantDetailsDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Testing
import Domain
import FoodybitePersistence

struct RestaurantDetailsDAOTests {

    @Test func getRestaurantDetails_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())

        do {
            let restaurantDetails = try await sut.getRestaurantDetails(restaurantID: "restaurant #1")
            Issue.record("Expected to fail, received \(restaurantDetails) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func getRestaurantDetails_returnsRestaurantDetailsForRestaurantIDWhenStoreContainsRestaurantDetails() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        storeSpy.readAllResult = .success(makeRestaurantsDetailsArray() + [expectedRestaurantDetails])

        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantDetails.id)
        #expect(receivedRestaurantDetails == expectedRestaurantDetails)
    }

    @Test func save_sendsRestaurantsDetailsToStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()

        try await sut.save(restaurantDetails: expectedRestaurantDetails)

        #expect(storeSpy.messages.count == 1)

        if case let .write(receivedRestaurantDetails) = storeSpy.messages[0],
           let receivedRestaurantDetails = receivedRestaurantDetails as? RestaurantDetails {
            #expect(expectedRestaurantDetails == receivedRestaurantDetails)
        } else {
            Issue.record("Expected .write message, got \(storeSpy.messages[0]) instead")
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: RestaurantDetailsDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = RestaurantDetailsDAO(store: storeSpy)
        return (sut, storeSpy)
    }

    private func makeRestaurantsDetailsArray() -> [RestaurantDetails] {
        [
            RestaurantDetails(id: "restaurant #1",
                         phoneNumber: "",
                         name: "",
                         address: "",
                         rating: 0,
                         openingHoursDetails: nil,
                         reviews: [],
                         location: Location(latitude: 0, longitude: 0),
                         photos: []),
            RestaurantDetails(id: "Place #2",
                         phoneNumber: "",
                         name: "",
                         address: "",
                         rating: 0,
                         openingHoursDetails: nil,
                         reviews: [],
                         location: Location(latitude: 0, longitude: 0),
                         photos: [])
        ]
    }

    private func makeRestaurantDetails() -> RestaurantDetails {
        RestaurantDetails(id: "Expected restaurant",
                     phoneNumber: "",
                     name: "",
                     address: "",
                     rating: 0,
                     openingHoursDetails: nil,
                     reviews: [],
                     location: Location(latitude: 0, longitude: 0),
                     photos: [])
    }

}
