//
//  GetReviewsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import XCTest
import Domain
import Foodybite

public protocol ReviewsCache {
    func save(reviews: [Review]) async throws
}

final class GetReviewsServiceCacheDecorator: GetReviewsService {
    private let getReviewsService: GetReviewsService
    private let cache: ReviewsCache
    
    init(getReviewsService: GetReviewsService, cache: ReviewsCache) {
        self.getReviewsService = getReviewsService
        self.cache = cache
    }
    
    func getReviews(placeID: String? = nil) async throws -> [Review] {
        try await getReviewsService.getReviews(placeID: placeID)
    }
}

final class GetReviewsServiceCacheDecoratorTests: XCTestCase {
    
    func test_getReviews_throwsErrorWhenGetReviewsServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let reviews = try await sut.getReviews()
            XCTFail("Expected to fail, received \(reviews) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getReviews_returnsReviewsWhenGetReviewsServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedReviews = makeReviews()
        serviceStub.stub = .success(expectedReviews)
        
        let receivedReviews = try await sut.getReviews()
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    func test_getReviews_doesNotCacheWhenGetReviewsServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        _ = try? await sut.getReviews()
        
        XCTAssertTrue(cacheSpy.capturedValues.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetReviewsServiceCacheDecorator, serviceStub: GetReviewsServiceStub, cacheSpy: ReviewsCacheSpy) {
        let serviceStub = GetReviewsServiceStub()
        let cacheSpy = ReviewsCacheSpy()
        let sut = GetReviewsServiceCacheDecorator(getReviewsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private func makeReviews() -> [Review] {
        [
            Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #1", rating: 2, relativeTime: "1 hour ago"),
            Review(placeID: "place #2", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #2", rating: 3, relativeTime: "one year ago"),
            Review(placeID: "place #3", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #3", rating: 4, relativeTime: "2 months ago")
        ]
    }
    
    private class ReviewsCacheSpy: ReviewsCache {
        private(set) var capturedValues = [[Review]]()
        
        func save(reviews: [Review]) async throws {
            capturedValues.append(reviews)
        }
    }
    
}
