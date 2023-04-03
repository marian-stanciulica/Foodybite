//
//  RestaurantDetailsDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class RestaurantDetailsDAOTests: XCTestCase {
    
    func test_getRestaurantDetails_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let restaurantDetails = try await sut.getRestaurantDetails(restaurantID: "place #1")
            XCTFail("Expected to fail, received \(restaurantDetails) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getRestaurantDetails_returnsRestaurantDetailsForRestaurantIDWhenStoreContainsRestaurantDetails() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        storeSpy.readAllResult = .success(makeRestaurantsDetailsArray() + [expectedRestaurantDetails])
        
        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantDetails.id)
        XCTAssertEqual(receivedRestaurantDetails, expectedRestaurantDetails)
    }
    
    func test_save_sendsPlaceDetailsToStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        
        try await sut.save(restaurantDetails: expectedRestaurantDetails)
        
        XCTAssertEqual(storeSpy.messages.count, 1)
        
        if case let .write(receivedRestaurantDetails) = storeSpy.messages[0] {
            XCTAssertEqual(expectedRestaurantDetails, receivedRestaurantDetails as! RestaurantDetails)
        } else {
            XCTFail("Expected .write message, got \(storeSpy.messages[0]) instead")
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
            RestaurantDetails(id: "Place #1",
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
        RestaurantDetails(id: "Expected place",
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
