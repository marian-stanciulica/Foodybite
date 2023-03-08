//
//  GetPlaceDetailsWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class GetPlaceDetailsWithFallbackComposite: GetPlaceDetailsService {
    private let primary: GetPlaceDetailsService
    private let secondary: GetPlaceDetailsService
    
    init(primary: GetPlaceDetailsService, secondary: GetPlaceDetailsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        do {
            return try await primary.getPlaceDetails(placeID: placeID)
        } catch {
            return try await secondary.getPlaceDetails(placeID: placeID)
        }
    }
}

final class GetPlaceDetailsWithFallbackCompositeTests: XCTestCase {
    
    func test_getPlaceDetails_returnsPlaceDetailsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        primaryStub.stub = .success(expectedPlaceDetails)
        
        let receivedPlaceDetails = try await sut.getPlaceDetails(placeID: expectedPlaceDetails.placeID)
        
        XCTAssertEqual(receivedPlaceDetails, expectedPlaceDetails)
    }
    
    func test_getPlaceDetails_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedPlaceID = "place id"
        primaryStub.stub = .failure(anyError())
        
        _ = try await sut.getPlaceDetails(placeID: expectedPlaceID)
        
        XCTAssertEqual(secondaryStub.capturedValues.count, 1)
        XCTAssertEqual(secondaryStub.capturedValues[0], expectedPlaceID)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsWithFallbackComposite, primaryStub: GetPlaceDetailsServiceStub, secondaryStub: GetPlaceDetailsServiceStub) {
        let primaryStub = GetPlaceDetailsServiceStub()
        let secondaryStub = GetPlaceDetailsServiceStub()
        let sut = GetPlaceDetailsWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
    private func makeExpectedPlaceDetails() -> PlaceDetails {
        PlaceDetails(placeID: "Expected place",
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

