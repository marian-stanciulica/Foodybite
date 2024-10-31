//
//  GetReviewsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Testing
import Domain
import Foodybite

struct GetReviewsServiceWithFallbackCompositeTests {

    @Test func getReviews_returnsReviewsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedReviews = makeReviews()
        primaryStub.stub = .success(expectedReviews)

        let receivedReviews = try await sut.getReviews()

        #expect(receivedReviews == expectedReviews)
    }

    @Test func getReviews_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedRestaurantID = "restaurant id"
        primaryStub.stub = .failure(anyError())

        _ = try await sut.getReviews(restaurantID: expectedRestaurantID)

        #expect(secondaryStub.capturedValues.count == 1)
        #expect(secondaryStub.capturedValues[0] == expectedRestaurantID)
    }

    @Test func getReviews_returnsReviewsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedReviews = makeReviews()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedReviews)

        let receivedReviews = try await sut.getReviews()

        #expect(expectedReviews == receivedReviews)
    }

    @Test func getReviews_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())

        do {
            let reviews = try await sut.getReviews()
            Issue.record("Expected to fail, got \(reviews) instead")
        } catch {
            #expect(error != nil)
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: GetReviewsServiceWithFallbackComposite,
        primaryStub: GetReviewsServiceStub,
        secondaryStub: GetReviewsServiceStub
    ) {
        let primaryStub = GetReviewsServiceStub()
        let secondaryStub = GetReviewsServiceStub()
        let sut = GetReviewsServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }

}
