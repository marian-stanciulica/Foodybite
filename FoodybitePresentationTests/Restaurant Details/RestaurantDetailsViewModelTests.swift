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
    
    func test_getPlaceDetails_sendsParamsToGetPlaceDetailsService() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT(input: .placeIdToFetch(anyPlaceID()))
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues, [anyPlaceID()])
    }
    
    func test_getPlaceDetails_doesNotSendParamsToGetPlaceDetailsServiceWhenInputIsFetchedPlaceDetails() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT(input: .fetchedPlaceDetails(anyPlaceDetails()))
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues, [])
    }
    
    func test_getPlaceDetails_setsErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT()
        getPlaceDetailsServiceSpy.result = .failure(anyError)
        
        await assertGetPlaceDetails(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_getPlaceDetails_updatesPlaceDetailsWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        
        await assertGetPlaceDetails(on: sut, withExpectedResult: .success(expectedPlaceDetails))
    }
    
    func test_getPlaceDetails_updatesPlaceDetailsWhenInputIsFetchedPlaceDetails() async {
        let expectedPlaceDetails = anyPlaceDetails()
        let (sut, _, _) = makeSUT(input: .fetchedPlaceDetails(expectedPlaceDetails))

        await assertGetPlaceDetails(on: sut, withExpectedResult: .success(expectedPlaceDetails))
    }
    
    func test_rating_returnsFormattedRating() {
        let (sut, _, _) = makeSUT()
        sut.getPlaceDetailsState = .success(anyPlaceDetails())
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let (sut, _, _) = makeSUT()
        sut.getPlaceDetailsState = .success(anyPlaceDetails())

        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "353.6")
    }
    
    func test_getPlaceReviews_sendsInputToGetReviewsService() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT(input: .placeIdToFetch(anyPlaceID()))
        sut.getPlaceDetailsState = .success(anyPlaceDetails())

        await sut.getPlaceReviews()
        
        XCTAssertEqual(getReviewsServiceSpy.capturedValues.first, anyPlaceID())
    }
    
    func test_getPlaceReviews_doesNotSendParamsToGetReviewsServiceWhenInputIsFetchedPlaceDetails() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT(input: .fetchedPlaceDetails(anyPlaceDetails()))
        
        await sut.getPlaceReviews()
        
        XCTAssertEqual(getReviewsServiceSpy.capturedValues, [])
    }
    
    func test_getPlaceReviews_appendsReviewsToPlaceDetailsWhenGetReviewsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, getReviewsServiceSpy) = makeSUT()
        let placeDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(placeDetails)
        await sut.getPlaceDetails()
        
        let anyPlaceReviews = placeDetails.reviews
        let getReviewsResult = firstGetReviewsResult()
        let expectedReviews = anyPlaceReviews + getReviewsResult
        
        getReviewsServiceSpy.result = getReviewsResult
        await sut.getPlaceReviews()
        
        XCTAssertEqual(sut.reviews, expectedReviews)
    }
    
    func test_getPlaceReviews_doesNotDuplicateReviewsWhenCalledTwice() async {
        let (sut, getPlaceDetailsServiceSpy, getReviewsServiceSpy) = makeSUT()
        let placeDetails = anyPlaceDetails()

        getPlaceDetailsServiceSpy.result = .success(placeDetails)
        await sut.getPlaceDetails()
        let anyPlaceReviews = placeDetails.reviews
        
        let firstGetReviewsResult = firstGetReviewsResult()
        getReviewsServiceSpy.result = firstGetReviewsResult
        await sut.getPlaceReviews()
        XCTAssertEqual(sut.reviews, anyPlaceReviews + firstGetReviewsResult)

        let secondGetReviewsResult = secondGetReviewsResult()
        getReviewsServiceSpy.result = secondGetReviewsResult
        await sut.getPlaceReviews()
        XCTAssertEqual(sut.reviews, anyPlaceReviews + secondGetReviewsResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(input: RestaurantDetailsViewModel.Input = .placeIdToFetch("")) -> (
        sut: RestaurantDetailsViewModel,
        getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy,
        getReviewsServiceSpy: GetReviewsServiceSpy
    ) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let getReviewsServiceSpy = GetReviewsServiceSpy()
        let sut = RestaurantDetailsViewModel(
            input: input,
            getDistanceInKmFromCurrentLocation: { _ in 353.6 },
            getPlaceDetailsService: getPlaceDetailsServiceSpy,
            getReviewsService: getReviewsServiceSpy
        )
        return (sut, getPlaceDetailsServiceSpy, getReviewsServiceSpy)
    }
    
    private func assertGetPlaceDetails(on sut: RestaurantDetailsViewModel,
                                       withExpectedResult expectedResult: RestaurantDetailsViewModel.State,
                                       file: StaticString = #file,
                                       line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.idle], file: file, line: line)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(resultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
        resultSpy.cancel()
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyPlaceDetails() -> RestaurantDetails {
        RestaurantDetails(
            placeID: "place #1",
            phoneNumber: "+61 2 9374 4000",
            name: "Place name",
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
                    "Sunday: Closed",
                ]
            ),
            reviews: [
                Review(
                    placeID: "place #1",
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
    
    private class GetPlaceDetailsServiceSpy: RestaurantDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<RestaurantDetails, Error>?
        
        func getRestaurantDetails(placeID: String) async throws -> RestaurantDetails {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return RestaurantDetails(placeID: "place #1",
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
                placeID: "place #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "It was quite nice!",
                rating: 4,
                relativeTime: ""),
        ]
    }
    
    private func secondGetReviewsResult() -> [Review] {
        [
            Review(
                placeID: "place #2",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #2",
                reviewText: "I didn't like it so much!",
                rating: 2,
                relativeTime: ""),
        ]
    }
    
    private class GetReviewsServiceSpy: GetReviewsService {
        private(set) var capturedValues = [String?]()
        var result = [Review]()
        
        func getReviews(placeID: String?) async throws -> [Review] {
            capturedValues.append(placeID)
            return result
        }
    }
    
}
