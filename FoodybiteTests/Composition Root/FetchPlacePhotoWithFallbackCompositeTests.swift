//
//  FetchPlacePhotoWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import XCTest
import Domain
import Foodybite

final class FetchPlacePhotoWithFallbackComposite: FetchPlacePhotoService {
    private let primary: FetchPlacePhotoService
    private let secondary: FetchPlacePhotoService
    
    init(primary: FetchPlacePhotoService, secondary: FetchPlacePhotoService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    func fetchPlacePhoto(photoReference: String) async throws -> Data {
        do {
            return try await primary.fetchPlacePhoto(photoReference: photoReference)
        } catch {
            return try await secondary.fetchPlacePhoto(photoReference: photoReference)
        }
    }
}

final class FetchPlacePhotoWithFallbackCompositeTests: XCTestCase {
    
    func test_fetchPlacePhoto_returnsPhotoDataWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedPhotoData = anyData()
        primaryStub.stub = .success(expectedPhotoData)
        
        let receivedPhotoData = try await sut.fetchPlacePhoto(photoReference: "")
        
        XCTAssertEqual(receivedPhotoData, expectedPhotoData)
    }
    
    func test_fetchPlacePhoto_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedPhotoReference = "photo reference"
        primaryStub.stub = .failure(anyError())
        
        _ = try await sut.fetchPlacePhoto(photoReference: expectedPhotoReference)
        
        XCTAssertEqual(secondaryStub.capturedValues.count, 1)
        XCTAssertEqual(secondaryStub.capturedValues[0], expectedPhotoReference)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: FetchPlacePhotoWithFallbackComposite, primaryStub: FetchPlacePhotoServiceStub, secondaryStub: FetchPlacePhotoServiceStub) {
        let primaryStub = FetchPlacePhotoServiceStub()
        let secondaryStub = FetchPlacePhotoServiceStub()
        let sut = FetchPlacePhotoWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
}
