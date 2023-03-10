//
//  FetchPlacePhotoWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import XCTest
import Domain
import Foodybite

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
    
    func test_fetchPlacePhoto_returnsPhotoDataWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedPhotoData = anyData()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedPhotoData)
        
        let receivedPhotoData = try await sut.fetchPlacePhoto(photoReference: "")
        
        XCTAssertEqual(expectedPhotoData, receivedPhotoData)
    }
    
    func test_fetchPlacePhoto_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())
        
        do {
            let photoData = try await sut.fetchPlacePhoto(photoReference: "")
            XCTFail("Expected to fail, got \(photoData) instead")
        } catch {
            XCTAssertNotNil(error)
        }
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
