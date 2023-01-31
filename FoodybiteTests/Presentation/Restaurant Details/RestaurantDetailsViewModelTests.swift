//
//  RestaurantDetailsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Foodybite
import DomainModels

final class RestaurantDetailsViewModelTests: XCTestCase {
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let (sut, serviceSpy, _) = makeSUT()
        serviceSpy.result = .failure(anyError)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(serviceSpy.placeID, anyPlaceID())
    }
    
    func test_getPlaceDetails_setsErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, serviceSpy, _) = makeSUT()
        
        serviceSpy.result = .failure(anyError)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.error, .connectionFailure)
        XCTAssertNil(sut.placeDetails)
    }
    
    func test_getPlaceDetails_updatesPlaceDetailsWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, serviceSpy, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails
        
        serviceSpy.result = .success(expectedPlaceDetails)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.placeDetails, expectedPlaceDetails)
        XCTAssertNil(sut.error)
    }
    
    func test_rating_returnsFormmatedRating() {
        let (sut, _, _) = makeSUT()
        sut.placeDetails = anyPlaceDetails
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let (sut, _, _) = makeSUT()
        sut.placeDetails = anyPlaceDetails
        
        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "6.5")
    }
    
    func test_fetchPhoto_sendsInputsToFetchPlacePhotoService() async {
        let (sut, serviceSpy, photoServiceSpy) = makeSUT()
        serviceSpy.result = .success(anyPlaceDetails)
        await sut.getPlaceDetails()

        await sut.fetchPhoto()

        XCTAssertEqual(photoServiceSpy.capturedValues[0], anyPhoto().photoReference)
    }
    
    func test_fetchPhoto_setsImageDataToNilWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, serviceSpy, photoServiceSpy) = makeSUT()
        serviceSpy.result = .success(anyPlaceDetails)
        await sut.getPlaceDetails()
        
        photoServiceSpy.result = .failure(anyError)
        await sut.fetchPhoto()
        XCTAssertNil(sut.imageData)
    }
    
    func test_fetchPhoto_updatesImageDataWhenFetchPlacePhotoServiceReturnsSuccessfully() async {
        let (sut, serviceSpy, photoServiceSpy) = makeSUT()
        let expectedData = anyData()

        serviceSpy.result = .success(anyPlaceDetails)
        await sut.getPlaceDetails()
        
        photoServiceSpy.result = .success(expectedData)
        await sut.fetchPhoto()
        XCTAssertEqual(sut.imageData, expectedData)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RestaurantDetailsViewModel, serviceSpy: GetPlaceDetailsServiceSpy, photoServiceSpy: FetchPlacePhotoServiceSpy) {
        let serviceSpy = GetPlaceDetailsServiceSpy()
        let photoServiceSpy = FetchPlacePhotoServiceSpy()
        let sut = RestaurantDetailsViewModel(placeID: anyPlaceID(), getPlaceDetailsService: serviceSpy, fetchPhotoService: photoServiceSpy)
        return (sut, serviceSpy, photoServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private var anyPlaceDetails: PlaceDetails {
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
                    profileImageURL: URL(string: "www.google.com")!,
                    authorName: "Marian",
                    reviewText: "Loren ipsum...",
                    rating: 2,
                    relativeTime: "5 months ago"
                )
            ],
            location: Location(latitude: 44.4, longitude: 26.09),
            photos: [anyPhoto()]
        )
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var placeID: String?
        var result: Result<PlaceDetails, Error>!
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            self.placeID = placeID
            return try result.get()
        }
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private func anyPhoto() -> Photo {
        Photo(width: 100, height: 200, photoReference: "photo reference")
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
