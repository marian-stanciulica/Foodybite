//
//  GetReviewsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import XCTest
import Domain
import Foodybite

final class GetReviewsServiceWithFallbackCompositeTests: XCTestCase {
    
    func test_getReviews_returnsReviewsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedReviews = makeReviews()
        primaryStub.stub = .success(expectedReviews)
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    func test_getReviews_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedPlaceID = "place id"
        primaryStub.stub = .failure(anyError())
        
        _ = try await sut.getReviews(placeID: expectedPlaceID)
        
        XCTAssertEqual(secondaryStub.capturedValues.count, 1)
        XCTAssertEqual(secondaryStub.capturedValues[0], expectedPlaceID)
    }
    
    func test_getReviews_returnsReviewsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedReviews = makeReviews()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedReviews)
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertEqual(expectedReviews, receivedReviews)
    }
    
    func test_getReviews_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())
        
        do {
            let reviews = try await sut.getReviews()
            XCTFail("Expected to fail, got \(reviews) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetReviewsServiceWithFallbackComposite, primaryStub: GetReviewsServiceStub, secondaryStub: GetReviewsServiceStub) {
        let primaryStub = GetReviewsServiceStub()
        let secondaryStub = GetReviewsServiceStub()
        let sut = GetReviewsServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
}
