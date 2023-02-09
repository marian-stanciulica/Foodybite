//
//  RestaurantDetailsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Foodybite
import Domain

final class RestaurantDetailsViewModelTests: XCTestCase {
    
    func test_getPlaceDetails_sendsParamsToGetPlaceDetailsService() async {
        let (sut, getPlaceDetailsServiceSpy, _, _) = makeSUT(input: .placeIdToFetch(anyPlaceID()))
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues, [anyPlaceID()])
    }
    
    func test_getPlaceDetails_doesNotSendParamsToGetPlaceDetailsServiceWhenInputIsFetchedPlaceDetails() async {
        let (sut, getPlaceDetailsServiceSpy, _, _) = makeSUT(input: .fetchedPlaceDetails(anyPlaceDetails()))
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues, [])
    }
    
    func test_getPlaceDetails_setsErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy, _, _) = makeSUT()
        
        getPlaceDetailsServiceSpy.result = .failure(anyError)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.error, .connectionFailure)
        XCTAssertNil(sut.placeDetails)
    }
    
    func test_getPlaceDetails_updatesPlaceDetailsWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, _, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.placeDetails, expectedPlaceDetails)
        XCTAssertNil(sut.error)
    }
    
    func test_getPlaceDetails_updatesPlaceDetailsWhenInputIsFetchedPlaceDetails() async {
        let expectedPlaceDetails = anyPlaceDetails()
        let (sut, _, _, _) = makeSUT(input: .fetchedPlaceDetails(expectedPlaceDetails))

        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.placeDetails, expectedPlaceDetails)
        XCTAssertNil(sut.error)
    }
    
    func test_getPlaceDetails_triggersFetchPhotoForFirstPhotoWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, photoServiceSpy, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(photoServiceSpy.capturedValues.first, expectedPlaceDetails.photos.first?.photoReference)
    }
    
    func test_getPlaceDetails_triggersFetchPhotoForFirstPhotoWhenInputIsFetchedPlaceDetails() async {
        let expectedPlaceDetails = anyPlaceDetails()
        let (sut, _, photoServiceSpy, _) = makeSUT(input: .fetchedPlaceDetails(expectedPlaceDetails))
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(photoServiceSpy.capturedValues.first, expectedPlaceDetails.photos.first?.photoReference)
    }
    
    func test_getPlaceDetails_initializesPhotosDataWithNilWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, _, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.photosData.count, expectedPlaceDetails.photos.count - 1)
        sut.photosData.forEach {
            XCTAssertNil($0)
        }
    }
    
    func test_getPlaceDetails_initializesPhotosDataWithNilWhenInputIsFetchedPlaceDetails() async {
        let expectedPlaceDetails = anyPlaceDetails()
        let (sut, _, _, _) = makeSUT(input: .fetchedPlaceDetails(expectedPlaceDetails))
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.photosData.count, expectedPlaceDetails.photos.count - 1)
        sut.photosData.forEach {
            XCTAssertNil($0)
        }
    }
    
    func test_rating_returnsFormattedRating() {
        let (sut, _, _, _) = makeSUT()
        sut.placeDetails = anyPlaceDetails()
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let (sut, _, _, _) = makeSUT()
        sut.placeDetails = anyPlaceDetails()
        
        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "353.6")
    }
    
    func test_fetchPhoto_sendsInputsToFetchPlacePhotoService() async {
        let (sut, _, photoServiceSpy, _) = makeSUT()

        _ = await sut.fetchPhoto(anyPhoto())

        XCTAssertEqual(photoServiceSpy.capturedValues.first, anyPhoto().photoReference)
    }
    
    func test_fetchPhoto_setsImageDataToNilWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, _, photoServiceSpy, _) = makeSUT()
        
        photoServiceSpy.result = .failure(anyError)
        _ = await sut.fetchPhoto(anyPhoto())
        XCTAssertNil(sut.imageData)
    }
    
    func test_fetchPhoto_updatesImageDataWhenFetchPlacePhotoServiceReturnsSuccessfully() async {
        let (sut, _, photoServiceSpy, _) = makeSUT()
        let expectedData = anyData()
        
        photoServiceSpy.result = .success(expectedData)
        let imageData = await sut.fetchPhoto(anyPhoto())
        XCTAssertEqual(imageData, expectedData)
    }
    
    func test_fetchPhotoAtIndex_requestsPhotoDataForTheGivenIndex() async {
        let (sut, _, photoServiceSpy, _) = makeSUT()
        sut.placeDetails = anyPlaceDetails()
        sut.photosData = Array(repeating: nil, count: anyPlaceDetails().photos.count - 1)
        
        await sut.fetchPhoto(at: 1)
        
        XCTAssertEqual(photoServiceSpy.capturedValues.first, anyPlaceDetails().photos[2].photoReference)
    }
    
    func test_fetchPhotoAtIndex_updatesPhotosDataAtGivenIndex() async {
        let (sut, _, photoServiceSpy, _) = makeSUT()
        let expectedData = anyData()
        
        sut.placeDetails = anyPlaceDetails()
        sut.photosData = Array(repeating: nil, count: anyPlaceDetails().photos.count - 1)
        
        photoServiceSpy.result = .success(expectedData)
        await sut.fetchPhoto(at: 1)
        
        XCTAssertEqual(sut.photosData[1], expectedData)
    }
    
    func test_getPlaceReviews_sendsInputToGetReviewsService() async {
        let (sut, _, _, getReviewsServiceSpy) = makeSUT(input: .placeIdToFetch(anyPlaceID()))
        sut.placeDetails = anyPlaceDetails()
        
        await sut.getPlaceReviews()
        
        XCTAssertEqual(getReviewsServiceSpy.capturedValues.first, anyPlaceID())
    }
    
    func test_getPlaceReviews_appendsReviewsToPlaceDetailsWhenGetReviewsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy, _, getReviewsServiceSpy) = makeSUT()
        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails())
        await sut.getPlaceDetails()
        
        let anyPlaceReviews = sut.placeDetails!.reviews
        let getReviewsResult = firstGetReviewsResult()
        let expectedReviews = anyPlaceReviews + getReviewsResult
        
        getReviewsServiceSpy.result = getReviewsResult
        await sut.getPlaceReviews()
        
        XCTAssertEqual(sut.placeDetails?.reviews, expectedReviews)
    }
    
    func test_getPlaceReviews_doesNotDuplicateReviewsWhenCalledTwice() async {
        let (sut, getPlaceDetailsServiceSpy, _, getReviewsServiceSpy) = makeSUT()
        
        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails())
        await sut.getPlaceDetails()
        let anyPlaceReviews = sut.placeDetails!.reviews
        
        let firstGetReviewsResult = firstGetReviewsResult()
        getReviewsServiceSpy.result = firstGetReviewsResult
        await sut.getPlaceReviews()
        XCTAssertEqual(sut.placeDetails?.reviews, anyPlaceReviews + firstGetReviewsResult)

        let secondGetReviewsResult = secondGetReviewsResult()
        getReviewsServiceSpy.result = secondGetReviewsResult
        await sut.getPlaceReviews()
        XCTAssertEqual(sut.placeDetails?.reviews, anyPlaceReviews + secondGetReviewsResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(input: RestaurantDetailsViewModel.Input = .placeIdToFetch("")) -> (sut: RestaurantDetailsViewModel,
                               getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy,
                               photoServiceSpy: FetchPlacePhotoServiceSpy,
                               getReviewsServiceSpy: GetReviewsServiceSpy
    ) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let photoServiceSpy = FetchPlacePhotoServiceSpy()
        let getReviewsServiceSpy = GetReviewsServiceSpy()
        let sut = RestaurantDetailsViewModel(
            input: input,
            currentLocation: anyLocation,
            getPlaceDetailsService: getPlaceDetailsServiceSpy,
            fetchPhotoService: photoServiceSpy,
            getReviewsService: getReviewsServiceSpy
        )
        return (sut, getPlaceDetailsServiceSpy, photoServiceSpy, getReviewsServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private var anyLocation: Location {
        Location(latitude: 2.3, longitude: 4.5)
    }
    
    private func anyPlaceDetails() -> PlaceDetails {
        PlaceDetails(
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
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<PlaceDetails, Error>?
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return PlaceDetails(phoneNumber: nil,
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
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
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
