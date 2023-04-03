//
//  RestaurantReviewCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import XCTest
import Domain
import FoodybitePresentation

final class RestaurantReviewCellViewModelTests: XCTestCase {
    
    func test_init_getRestaurantDetailsStateIsLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.getRestaurantDetailsState, .idle)
    }
    
    func test_getRestaurantDetails_sendsInputsToRestaurantDetailsService() async {
        let review = Self.anyReview()
        let (sut, restaurantDetailsServiceSpy) = makeSUT(review: review)
        
        await sut.getRestaurantDetails()
        
        XCTAssertEqual(restaurantDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(restaurantDetailsServiceSpy.capturedValues.first, review.placeID)
    }
    
    func test_getRestaurantDetails_setsGetRestaurantDetailsStateToLoadingErrorWhenRestaurantDetailsServiceThrowsError() async {
        let (sut, restaurantDetailsServiceSpy) = makeSUT()
        restaurantDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getRestaurantDetailsState.eraseToAnyPublisher())

        await sut.getRestaurantDetails()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .failure(.serverError)])
    }
    
    func test_getRestaurantDetails_setsGetRestaurantDetailsStateToRequestSucceeededWhenRestaurantDetailsServiceReturnsSuccessfully() async {
        let (sut, restaurantDetailsServiceSpy) = makeSUT()
        let expectedRestaurantDetails = anyRestaurantDetails()
        restaurantDetailsServiceSpy.result = .success(expectedRestaurantDetails)
        let stateSpy = PublisherSpy(sut.$getRestaurantDetailsState.eraseToAnyPublisher())

        await sut.getRestaurantDetails()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .success(expectedRestaurantDetails)])
    }
    
    func test_rating_returnsFormattedRating() {
        let review = Self.anyReview()
        let (sut, _) = makeSUT(review: review)
        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())
        
        XCTAssertEqual(sut.rating, "\(review.rating)")
    }
    
    func test_restaurantName_initiallySetToEmpty() {
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.restaurantName.isEmpty)
    }
    
    func test_restaurantName_equalsFetchedRestaurantDetailsName() async {
        let (sut, restaurantDetailsServiceSpy) = makeSUT()
        let anyRestaurantDetails = anyRestaurantDetails()
        restaurantDetailsServiceSpy.result = .success(anyRestaurantDetails)

        await sut.getRestaurantDetails()

        XCTAssertEqual(sut.restaurantName, anyRestaurantDetails.name)
    }
    
    func test_restaurantAddress_initiallySetToEmpty() {
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.restaurantAddress.isEmpty)
    }
    
    func test_restaurantAddress_equalsFetchedPlaceDetailsAddress() async {
        let (sut, restaurantDetailsServiceSpy) = makeSUT()
        let anyRestaurantDetails = anyRestaurantDetails()
        restaurantDetailsServiceSpy.result = .success(anyRestaurantDetails)

        await sut.getRestaurantDetails()

        XCTAssertEqual(sut.restaurantAddress, anyRestaurantDetails.address)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(review: Review = anyReview()) -> (sut: RestaurantReviewCellViewModel, restaurantDetailsServiceSpy: RestaurantDetailsServiceSpy) {
        let restaurantDetailsServiceSpy = RestaurantDetailsServiceSpy()
        let sut = RestaurantReviewCellViewModel(review: review, restaurantDetailsService: restaurantDetailsServiceSpy)
        return (sut, restaurantDetailsServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private static func anyReview() -> Review {
        Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author", reviewText: "very nice", rating: 5, relativeTime: "1 hour ago")
    }
    
    private func anyRestaurantDetails() -> RestaurantDetails {
        RestaurantDetails(
            placeID: "place #1",
            phoneNumber: "+61 2 9374 4000",
            name: "Place name",
            address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
            rating: 3.4,
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
    
    private func anyPhotos() -> [Photo] {
        [
            Photo(width: 100, height: 200, photoReference: "first photo reference"),
            Photo(width: 200, height: 300, photoReference: "second photo reference"),
            Photo(width: 300, height: 400, photoReference: "third photo reference")
        ]
    }
    
    private class RestaurantDetailsServiceSpy: RestaurantDetailsService {
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
                                photos: []
            )
        }
    }
}
