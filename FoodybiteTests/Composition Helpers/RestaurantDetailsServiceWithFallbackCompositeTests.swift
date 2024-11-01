//
//  RestaurantDetailsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class RestaurantDetailsServiceWithFallbackCompositeTests: XCTestCase {

    func test_getRestaurantDetails_returnsRestaurantDetailsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        primaryStub.stub = .success(expectedRestaurantDetails)

        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantDetails.id)

        XCTAssertEqual(receivedRestaurantDetails, expectedRestaurantDetails)
    }

    func test_getRestaurantDetails_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedRestaurantID = "restaurant id"
        primaryStub.stub = .failure(anyError())

        _ = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantID)

        XCTAssertEqual(secondaryStub.capturedValues.count, 1)
        XCTAssertEqual(secondaryStub.capturedValues[0], expectedRestaurantID)
    }

    func test_getRestaurantDetails_returnsRestaurantDetailsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedRestaurantDetails)

        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: expectedRestaurantDetails.id)

        XCTAssertEqual(receivedRestaurantDetails, expectedRestaurantDetails)
    }

    func test_getRestaurantDetails_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())

        do {
            let restaurantDetails = try await sut.getRestaurantDetails(restaurantID: "restaurant id")
            XCTFail("Expected to fail, got \(restaurantDetails) instead")
        } catch {
            XCTAssertNotNil(error)
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
