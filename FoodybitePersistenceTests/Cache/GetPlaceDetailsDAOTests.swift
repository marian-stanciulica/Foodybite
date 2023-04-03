//
//  GetPlaceDetailsDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class GetPlaceDetailsDAOTests: XCTestCase {
    
    func test_getPlaceDetails_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let nearbyPlaces = try await sut.getPlaceDetails(placeID: "place #1")
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getPlaceDetails_returnsPlaceDetailsForPlaceIdWhenStoreContainsPlaceDetails() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        storeSpy.readAllResult = .success(makePlaceDetails() + [expectedPlaceDetails])
        
        let receivedPlaceDetails = try await sut.getPlaceDetails(placeID: expectedPlaceDetails.placeID)
        XCTAssertEqual(receivedPlaceDetails, expectedPlaceDetails)
    }
    
    func test_save_sendsPlaceDetailsToStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        
        try await sut.save(placeDetails: expectedPlaceDetails)
        
        XCTAssertEqual(storeSpy.messages.count, 1)
        
        if case let .write(receivedPlaceDetails) = storeSpy.messages[0] {
            XCTAssertEqual(expectedPlaceDetails, receivedPlaceDetails as! RestaurantDetails)
        } else {
            XCTFail("Expected .write message, got \(storeSpy.messages[0]) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = GetPlaceDetailsDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
    private func makePlaceDetails() -> [RestaurantDetails] {
        [
            RestaurantDetails(placeID: "Place #1",
                         phoneNumber: "",
                         name: "",
                         address: "",
                         rating: 0,
                         openingHoursDetails: nil,
                         reviews: [],
                         location: Location(latitude: 0, longitude: 0),
                         photos: []),
            RestaurantDetails(placeID: "Place #2",
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
    
    private func makeExpectedPlaceDetails() -> RestaurantDetails {
        RestaurantDetails(placeID: "Expected place",
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
