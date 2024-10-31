//
//  GetReviewsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Testing
import Domain
import Foodybite

struct GetReviewsServiceCacheDecoratorTests {

    @Test func getReviews_throwsErrorWhenGetReviewsServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())

        do {
            let reviews = try await sut.getReviews()
            Issue.record("Expected to fail, received \(reviews) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func getReviews_returnsReviewsWhenGetReviewsServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedReviews = makeReviews()
        serviceStub.stub = .success(expectedReviews)

        let receivedReviews = try await sut.getReviews()
        #expect(receivedReviews == expectedReviews)
    }

    @Test func getReviews_doesNotCacheWhenGetReviewsServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())

        _ = try? await sut.getReviews()

        #expect(cacheSpy.capturedValues.isEmpty)
    }

    @Test func getReviews_cachesReviewsWhenGetReviewsServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedReviews = makeReviews()
        serviceStub.stub = .success(expectedReviews)

        _ = try? await sut.getReviews()

        #expect(cacheSpy.capturedValues == [expectedReviews])
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
