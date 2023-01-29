//
//  RestaurantCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import XCTest
import Foodybite
import DomainModels

final class RestaurantCellViewModelTests: XCTestCase {
    
    func test_rating_returnsFormmatedRating() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "6.5")
    }
    
    func test_isOpen_equalsNearbyPlaceIsOpen() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.isOpen, isOpen())
    }
    
    func test_placeName_equalsNearbyPlaceName() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.placeName, anyPlaceName())
    }
    
    func test_fetchPhoto_sendsInputsToFetchPlacePhotoService() async {
        let (sut, serviceSpy) = makeSUT()

        await sut.fetchPhoto()

        XCTAssertEqual(serviceSpy.capturedValues[0], anyPhoto().photoReference)
    }
    
    func test_fetchPhoto_setsImageDataToNilWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        
        serviceSpy.result = .failure(anyError)
        await sut.fetchPhoto()
        XCTAssertNil(sut.imageData)
    }
    
    func test_fetchPhoto_updatesImageDataWhenFetchPlacePhotoServiceReturnsSuccessfully() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedData = anyData()
        
        serviceSpy.result = .success(expectedData)
        await sut.fetchPhoto()
        XCTAssertEqual(sut.imageData, expectedData)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RestaurantCellViewModel, serviceSpy: FetchPlacePhotoServiceSpy) {
        let serviceSpy = FetchPlacePhotoServiceSpy()
        let sut = RestaurantCellViewModel(
            nearbyPlace: NearbyPlace(
                placeID: UUID().uuidString,
                placeName: anyPlaceName(),
                isOpen: isOpen(),
                rating: rating().raw,
                location: Location(latitude: 44.4, longitude: 26.09),
                photo: anyPhoto()
            ),
            fetchPhotoService: serviceSpy
        )
        return (sut, serviceSpy)
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
    private func isOpen() -> Bool {
        return true
    }
    
    private func anyPlaceName() -> String {
        "Place name"
    }
    
    private func anyPhoto() -> Photo {
        Photo(width: 100, height: 200, photoReference: "photo reference")
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
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
