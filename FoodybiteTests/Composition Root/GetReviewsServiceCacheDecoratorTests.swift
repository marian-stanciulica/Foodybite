//
//  GetReviewsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import XCTest
import Domain
import Foodybite

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
    
    func test_getReviews_cachesReviewsWhenGetReviewsServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedReviews = makeReviews()
        serviceStub.stub = .success(expectedReviews)
        
        _ = try? await sut.getReviews()
        
        XCTAssertEqual(cacheSpy.capturedValues, [expectedReviews])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetReviewsServiceCacheDecorator, serviceStub: GetReviewsServiceStub, cacheSpy: ReviewsCacheSpy) {
        let serviceStub = GetReviewsServiceStub()
        let cacheSpy = ReviewsCacheSpy()
        let sut = GetReviewsServiceCacheDecorator(getReviewsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private class ReviewsCacheSpy: ReviewCache {
        private(set) var capturedValues = [[Review]]()
        
        func save(reviews: [Review]) async throws {
            capturedValues.append(reviews)
        }
    }
    
}
