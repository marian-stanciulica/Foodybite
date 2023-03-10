//
//  FetchPlacePhotoServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import XCTest
import Domain
import Foodybite

final class FetchPlacePhotoServiceCacheDecoratorTests: XCTestCase {
    
    func test_fetchPlacePhoto_throwsErrorWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let photoData = try await sut.fetchPlacePhoto(photoReference: "")
            XCTFail("Expected to fail, received \(photoData) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_fetchPlacePhoto_returnsPhotoDataWhenFetchPlacePhotoServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedPhotoData = anyData()
        serviceStub.stub = .success(expectedPhotoData)
        
        let receivedPhotoData = try await sut.fetchPlacePhoto(photoReference: "")
        XCTAssertEqual(receivedPhotoData, expectedPhotoData)
    }
    
    func test_fetchPlacePhoto_doesNotCacheWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        _ = try? await sut.fetchPlacePhoto(photoReference: "")
        
        XCTAssertTrue(cacheSpy.capturedValues.isEmpty)
    }
    
    func test_fetchPlacePhoto_cachesPhotoDataWhenFetchPlacePhotoServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedPhotoData = anyData()
        let expectedReference = "expected reference"
        serviceStub.stub = .success(expectedPhotoData)
        
        _ = try? await sut.fetchPlacePhoto(photoReference: expectedReference)
        
        XCTAssertEqual(cacheSpy.capturedValues.count, 1)
        XCTAssertEqual(cacheSpy.capturedValues[0].photoReference, expectedReference)
        XCTAssertEqual(cacheSpy.capturedValues[0].photoData, expectedPhotoData)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: FetchPlacePhotoServiceCacheDecorator, serviceStub: FetchPlacePhotoServiceStub, cacheSpy: PlacePhotoCacheSpy) {
        let serviceStub = FetchPlacePhotoServiceStub()
        let cacheSpy = PlacePhotoCacheSpy()
        let sut = FetchPlacePhotoServiceCacheDecorator(fetchPlacePhotoService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private class PlacePhotoCacheSpy: PlacePhotoCache {
        private(set) var capturedValues = [(photoData: Data, photoReference: String)]()
        
        func save(photoData: Data, for photoReference: String) async throws {
            capturedValues.append((photoData, photoReference))
        }
    }
}
