//
//  FetchPlacePhotoServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import XCTest
import Domain
import Foodybite

final class FetchPlacePhotoServiceCacheDecorator: FetchPlacePhotoService {
    private let fetchPlacePhotoService: FetchPlacePhotoService
    private let cache: PlacePhotoCache
    
    init(fetchPlacePhotoService: FetchPlacePhotoService, cache: PlacePhotoCache) {
        self.fetchPlacePhotoService = fetchPlacePhotoService
        self.cache = cache
    }
    
    func fetchPlacePhoto(photoReference: String) async throws -> Data {
        throw NSError(domain: "", code: 1)
    }
}

final class FetchPlacePhotoServiceCacheDecoratorTests: XCTestCase {
    
    func test_fetchPlacePhoto_throwsErrorWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let photoData = try await sut.fetchPlacePhoto(photoReference: "reference")
            XCTFail("Expected to fail, received \(photoData) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: FetchPlacePhotoServiceCacheDecorator, serviceStub: FetchPlacePhotoServiceStub, cacheSpy: PlacePhotoCacheSpy) {
        let serviceStub = FetchPlacePhotoServiceStub()
        let cacheSpy = PlacePhotoCacheSpy()
        let sut = FetchPlacePhotoServiceCacheDecorator(fetchPlacePhotoService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private class PlacePhotoCacheSpy: PlacePhotoCache {
        private(set) var capturedValues = [(photoData: Data, photoReference: String)]()
        
        func save(photoData: Data, for photoReference: String) async throws {
            capturedValues.append((photoData, photoReference))
        }
    }
}
