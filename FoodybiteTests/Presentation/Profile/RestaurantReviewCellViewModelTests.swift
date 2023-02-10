//
//  RestaurantReviewCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import XCTest
import Domain
import Foodybite

final class RestaurantReviewCellViewModelTests: XCTestCase {
    
    func test_init_getPlaceDetailsStateIsLoading() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .isLoading)
    }
    
    func test_init_getPlacePhotoStateIsLoading() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.fetchPhotoState, .isLoading)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let review = Self.anyReview()
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT(review: review)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, review.placeID)
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateToLoadingErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT()
        getPlaceDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .loadingError("An error occured while fetching review details. Please try again later!")])
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateToRequestSucceeededWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .requestSucceeeded(expectedPlaceDetails)])
    }
    
    func test_getPlaceDetails_triggersFetchPhoto() async {
        let (sut, getPlaceDetailsServiceSpy, photoServiceSpy) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(photoServiceSpy.capturedValues.first, expectedPlaceDetails.photos.first?.photoReference)
    }
    
    func test_fetchPhoto_setsFetchPhotoStateToLoadingErrorWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy, photoServiceSpy) = makeSUT()
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())

        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails())
        photoServiceSpy.result = .failure(anyError())
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .loadingError("An error occured while fetching place photo. Please try again later!")])
    }
    
    func test_fetchPhoto_setsFetchPhotoStateToRequestSucceeededWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy, photoServiceSpy) = makeSUT()
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())
        let expectedData = anyData()
        
        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails())
        photoServiceSpy.result = .success(expectedData)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .requestSucceeeded(expectedData)])
    }
    
    func test_rating_returnsFormattedRating() {
        let review = Self.anyReview()
        let (sut, _, _) = makeSUT(review: review)
        sut.getPlaceDetailsState = .requestSucceeeded(anyPlaceDetails())
        
        XCTAssertEqual(sut.rating, "\(review.rating)")
    }
    
    func test_placeName_initiallySetToEmpty() {
        let (sut, _, _) = makeSUT()

        XCTAssertTrue(sut.placeName.isEmpty)
    }
    
    func test_placeName_equalsFetchedPlaceDetailsName() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT()
        let anyPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails)

        await sut.getPlaceDetails()

        XCTAssertEqual(sut.placeName, anyPlaceDetails.name)
    }
    
    func test_placeAddress_initiallySetToEmpty() {
        let (sut, _, _) = makeSUT()

        XCTAssertTrue(sut.placeAddress.isEmpty)
    }
    
    func test_placeAddress_equalsFetchedPlaceDetailsAddress() async {
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT()
        let anyPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails)

        await sut.getPlaceDetails()

        XCTAssertEqual(sut.placeAddress, anyPlaceDetails.address)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(review: Review = anyReview()) -> (sut: RestaurantReviewCellViewModel, getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy, fetchPlacePhotoServiceSpy: FetchPlacePhotoServiceSpy) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let fetchPlacePhotoServiceSpy = FetchPlacePhotoServiceSpy()
        let sut = RestaurantReviewCellViewModel(review: review, getPlaceDetailsService: getPlaceDetailsServiceSpy, fetchPlacePhotoService: fetchPlacePhotoServiceSpy)
        return (sut, getPlaceDetailsServiceSpy, fetchPlacePhotoServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private static func anyReview() -> Review {
        Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author", reviewText: "very nice", rating: 5, relativeTime: "1 hour ago")
    }
    
    private func anyPlaceDetails() -> PlaceDetails {
        PlaceDetails(
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
    
    private func anyPhoto() -> Photo {
        Photo(width: 10, height: 20, photoReference: "photo reference")
    }
    
    private func anyPhotos() -> [Photo] {
        [
            Photo(width: 100, height: 200, photoReference: "first photo reference"),
            Photo(width: 200, height: 300, photoReference: "second photo reference"),
            Photo(width: 300, height: 400, photoReference: "third photo reference")
        ]
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<PlaceDetails, Error>?
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return PlaceDetails(placeID: "place #1",
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
    
    private class FetchPlacePhotoServiceSpy: FetchPlacePhotoService {
        var result: Result<Data, Error>?
        private(set) var capturedValues = [String]()

        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            capturedValues.append(photoReference)
            
            if let result = result {
                return try result.get()
            }
            
            return Data()
        }
    }
    
}