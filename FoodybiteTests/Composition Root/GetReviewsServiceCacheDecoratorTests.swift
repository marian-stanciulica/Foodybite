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
        throw NSError(domain: "", code: 1)
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
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetReviewsServiceCacheDecorator, serviceStub: GetReviewsServiceStub, cacheSpy: ReviewsCacheSpy) {
        let serviceStub = GetReviewsServiceStub()
        let cacheSpy = ReviewsCacheSpy()
        let sut = GetReviewsServiceCacheDecorator(getReviewsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private class ReviewsCacheSpy: ReviewsCache {
        private(set) var capturedValues = [[Review]]()
        
        func save(reviews: [Review]) async throws {
            capturedValues.append(reviews)
        }
    }
    
}
