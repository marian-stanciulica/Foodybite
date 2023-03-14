//
//  GetReviewsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import XCTest
import Domain
import Foodybite

final class GetReviewsServiceWithFallbackComposite: GetReviewsService {
    private let primary: GetReviewsService
    private let secondary: GetReviewsService
    
    init(primary: GetReviewsService, secondary: GetReviewsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    func getReviews(placeID: String? = nil) async throws -> [Review] {
        try await primary.getReviews(placeID: placeID)
    }
}

final class GetReviewsServiceWithFallbackCompositeTests: XCTestCase {
    
    func test_getReviews_returnsReviewsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedReviews = makeReviews()
        primaryStub.stub = .success(expectedReviews)
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetReviewsServiceWithFallbackComposite, primaryStub: GetReviewsServiceStub, secondaryStub: GetReviewsServiceStub) {
        let primaryStub = GetReviewsServiceStub()
        let secondaryStub = GetReviewsServiceStub()
        let sut = GetReviewsServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
}
