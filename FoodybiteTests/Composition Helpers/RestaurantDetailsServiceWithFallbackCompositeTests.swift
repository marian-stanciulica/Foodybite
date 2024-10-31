//
//  RestaurantDetailsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Testing
import Domain
import Foodybite

struct RestaurantDetailsServiceWithFallbackCompositeTests {

    @Test func getRestaurantDetails_returnsRestaurantDetailsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        primaryStub.stub = .success(expectedRestaurantDetails)

        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantDetails.id)

        #expect(receivedRestaurantDetails == expectedRestaurantDetails)
    }

    @Test func getRestaurantDetails_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedRestaurantID = "restaurant id"
        primaryStub.stub = .failure(anyError())

        _ = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantID)

        #expect(secondaryStub.capturedValues.count == 1)
        #expect(secondaryStub.capturedValues[0] == expectedRestaurantID)
    }

    @Test func getRestaurantDetails_returnsRestaurantDetailsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedRestaurantDetails)

        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantDetails.id)

        #expect(receivedRestaurantDetails == expectedRestaurantDetails)
    }

    @Test func getRestaurantDetails_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())

        do {
            let restaurantDetails = try await sut.getRestaurantDetails(restaurantID: "restaurant id")
            Issue.record("Expected to fail, got \(restaurantDetails) instead")
        } catch {
            #expect(error != nil)
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: RestaurantDetailsServiceWithFallbackComposite,
        primaryStub: RestaurantDetailsServiceStub,
        secondaryStub: RestaurantDetailsServiceStub
    ) {
        let primaryStub = RestaurantDetailsServiceStub()
        let secondaryStub = RestaurantDetailsServiceStub()
        let sut = RestaurantDetailsServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }

}
