//
//  RestaurantDetailsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Domain
import FoodybitePresentation

final class RestaurantDetailsViewModelTests: XCTestCase {

    func test_getRestaurantDetails_sendsParamsToRestaurantDetailsService() async {
        let (sut, restaurantDetailsServiceSpy, _) = makeSUT(input: .restaurantIdToFetch(anyRestaurantID()))

        await sut.getRestaurantDetails()

        XCTAssertEqual(restaurantDetailsServiceSpy.capturedValues, [anyRestaurantID()])
    }

    func test_getRestaurantDetails_doesNotSendParamsToRestaurantDetailsServiceWhenInputIsFetchedRestaurantDetails() async {
        let (sut, restaurantDetailsServiceSpy, _) = makeSUT(input: .fetchedRestaurantDetails(anyRestaurantDetails()))

        await sut.getRestaurantDetails()

        XCTAssertEqual(restaurantDetailsServiceSpy.capturedValues, [])
    }

    func test_getRestaurantDetails_setsErrorWhenRestaurantDetailsServiceThrowsError() async {
        let (sut, restaurantDetailsServiceSpy, _) = makeSUT()
        restaurantDetailsServiceSpy.result = .failure(anyError)

        await assertGetRestaurantDetails(on: sut, withExpectedResult: .failure(.serverError))
    }

    func test_getRestaurantDetails_updatesRestaurantDetailsWhenRestaurantDetailsServiceReturnsSuccessfully() async {
        let (sut, restaurantDetailsServiceSpy, _) = makeSUT()
        let expectedRestaurantDetails = anyRestaurantDetails()
        restaurantDetailsServiceSpy.result = .success(expectedRestaurantDetails)

        await assertGetRestaurantDetails(on: sut, withExpectedResult: .success(expectedRestaurantDetails))
    }

    func test_getRestaurantDetails_updatesRestaurantDetailsWhenInputIsFetchedRestaurantDetails() async {
        let expectedRestaurantDetails = anyRestaurantDetails()
        let (sut, _, _) = makeSUT(input: .fetchedRestaurantDetails(expectedRestaurantDetails))

        await assertGetRestaurantDetails(on: sut, withExpectedResult: .success(expectedRestaurantDetails))
    }

    func test_rating_returnsFormattedRating() {
        let (sut, _, _) = makeSUT()
        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())

        XCTAssertEqual(sut.rating, rating().formatted)
    }

    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let (sut, _, _) = makeSUT()
        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())

        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "353.6")
    }

    func test_getRestaurantReviews_sendsInputToGetReviewsService() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT(input: .restaurantIdToFetch(anyRestaurantID()))
        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())

        await sut.getRestaurantReviews()

        XCTAssertEqual(getReviewsServiceSpy.capturedValues.first, anyRestaurantID())
    }

    func test_getRestaurantReviews_doesNotSendParamsToGetReviewsServiceWhenInputIsFetchedRestaurantDetails() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT(input: .fetchedRestaurantDetails(anyRestaurantDetails()))

        await sut.getRestaurantReviews()

        XCTAssertEqual(getReviewsServiceSpy.capturedValues, [])
    }

    func test_getRestaurantReviews_appendsReviewsToRestaurantDetailsWhenGetReviewsServiceReturnsSuccessfully() async {
        let (sut, restaurantDetailsServiceSpy, getReviewsServiceSpy) = makeSUT()
        let restaurantDetails = anyRestaurantDetails()
        restaurantDetailsServiceSpy.result = .success(restaurantDetails)
        await sut.getRestaurantDetails()

        let anyRestaurantReviews = restaurantDetails.reviews
        let getReviewsResult = firstGetReviewsResult()
        let expectedReviews = anyRestaurantReviews + getReviewsResult

        getReviewsServiceSpy.result = getReviewsResult
        await sut.getRestaurantReviews()

        XCTAssertEqual(sut.reviews, expectedReviews)
    }

    func test_getRestaurantReviews_doesNotDuplicateReviewsWhenCalledTwice() async {
        let (sut, restaurantDetailsServiceSpy, getReviewsServiceSpy) = makeSUT()
        let restaurantDetails = anyRestaurantDetails()

        restaurantDetailsServiceSpy.result = .success(restaurantDetails)
        await sut.getRestaurantDetails()
        let anyRestaurantReviews = restaurantDetails.reviews

        let firstGetReviewsResult = firstGetReviewsResult()
        getReviewsServiceSpy.result = firstGetReviewsResult
        await sut.getRestaurantReviews()
        XCTAssertEqual(sut.reviews, anyRestaurantReviews + firstGetReviewsResult)

        let secondGetReviewsResult = secondGetReviewsResult()
        getReviewsServiceSpy.result = secondGetReviewsResult
        await sut.getRestaurantReviews()
        XCTAssertEqual(sut.reviews, anyRestaurantReviews + secondGetReviewsResult)
    }

    // MARK: - Helpers

    private func makeSUT(input: RestaurantDetailsViewModel.Input = .restaurantIdToFetch("")) -> (
        sut: RestaurantDetailsViewModel,
        restaurantDetailsServiceSpy: RestaurantDetailsServiceSpy,
        getReviewsServiceSpy: GetReviewsServiceSpy
    ) {
        let restaurantDetailsServiceSpy = RestaurantDetailsServiceSpy()
        let getReviewsServiceSpy = GetReviewsServiceSpy()
        let sut = RestaurantDetailsViewModel(
            input: input,
            getDistanceInKmFromCurrentLocation: { _ in 353.6 },
            restaurantDetailsService: restaurantDetailsServiceSpy,
            getReviewsService: getReviewsServiceSpy
        )
        return (sut, restaurantDetailsServiceSpy, getReviewsServiceSpy)
    }

    private func assertGetRestaurantDetails(
        on sut: RestaurantDetailsViewModel,
        withExpectedResult expectedResult: RestaurantDetailsViewModel.State,
        file: StaticString = #file,
        line: UInt = #line
    ) async {
        let resultSpy = PublisherSpy(sut.$getRestaurantDetailsState.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.idle], file: file, line: line)

        await sut.getRestaurantDetails()

        XCTAssertEqual(resultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
        resultSpy.cancel()
    }

    private func anyRestaurantID() -> String {
        "any restaurant id"
    }

    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }

    private func anyRestaurantDetails() -> RestaurantDetails {
        RestaurantDetails(
            id: "restaurant #1",
            phoneNumber: "+61 2 9374 4000",
            name: "restaurant name",
            address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
            rating: rating().raw,
            openingHoursDetails: OpeningHoursDetails(
                openNow: true,
                weekdayText: [
                    "Monday: 9:00 AM – 5:00 PM",
                    "Tuesday: 9:00 AM – 5:00 PM",
                    "Wednesday: 9:00 AM – 5:00 PM",
                    "Thursday: 9:00 AM – 5:00 PM",
                    "Friday: 9:00 AM – 5:00 PM",
                    "Saturday: Closed",
                    "Sunday: Closed"
                ]
            ),
            reviews: [
                Review(
                    restaurantID: "restaurant #1",
                    profileImageURL: URL(string: "www.google.com"),
                    profileImageData: nil,
                    authorName: "Marian",
                    reviewText: "Loren ipsum...",
                    rating: 2,
                    relativeTime: "5 months ago"
                )
            ],
            location: Location(latitude: 4.4, longitude: 6.9),
            photos: anyPhotos()
        )
    }

    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }

    private class RestaurantDetailsServiceSpy: RestaurantDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<RestaurantDetails, Error>?

        func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
            capturedValues.append(restaurantID)

            if let result = result {
                return try result.get()
            }

            return RestaurantDetails(id: "restaurant #1",
                                phoneNumber: nil,
                                name: "",
                                address: "",
                                rating: 0,
                                openingHoursDetails: nil,
                                reviews: [],
                                location: Location(latitude: 0, longitude: 0),
                                photos: [Photo(width: 100, height: 100, photoReference: "")]
            )
        }
    }

    private func anyPhotos() -> [Photo] {
        [
            Photo(width: 100, height: 200, photoReference: "first photo reference"),
            Photo(width: 200, height: 300, photoReference: "second photo reference"),
            Photo(width: 300, height: 400, photoReference: "third photo reference")
        ]
    }

    private func firstGetReviewsResult() -> [Review] {
        [
            Review(
                restaurantID: "restaurant #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "It was quite nice!",
                rating: 4,
                relativeTime: "")
        ]
    }

    private func secondGetReviewsResult() -> [Review] {
        [
            Review(
                restaurantID: "restaurant #2",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #2",
                reviewText: "I didn't like it so much!",
                rating: 2,
                relativeTime: "")
        ]
    }

    private class GetReviewsServiceSpy: GetReviewsService {
        private(set) var capturedValues = [String?]()
        var result = [Review]()

        func getReviews(restaurantID: String?) async throws -> [Review] {
            capturedValues.append(restaurantID)
            return result
        }
    }

}
