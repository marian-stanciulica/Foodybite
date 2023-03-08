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
    
    func test_getPlaceDetails_returnsPlaceDetailsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedPlaceDetails)
        
        let receivedPlaceDetails = try await sut.getPlaceDetails(placeID: expectedPlaceDetails.placeID)
        
        XCTAssertEqual(expectedPlaceDetails, receivedPlaceDetails)
    }
    
    func test_getPlaceDetails_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())
        
        do {
            let placeDetails = try await sut.getPlaceDetails(placeID: "place id")
            XCTFail("Expected to fail, got \(placeDetails) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsWithFallbackComposite, primaryStub: GetPlaceDetailsServiceStub, secondaryStub: GetPlaceDetailsServiceStub) {
        let primaryStub = GetPlaceDetailsServiceStub()
        let secondaryStub = GetPlaceDetailsServiceStub()
        let sut = GetPlaceDetailsWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
}

