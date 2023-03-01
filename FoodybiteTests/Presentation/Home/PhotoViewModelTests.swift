//
//  PhotoViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import XCTest
import Domain
import Foodybite

final class PhotoViewModelTests: XCTestCase {
    
    func test_init_getPlacePhotoStateIsLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.fetchPhotoState, .isLoading)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: PhotoViewModel, fetchPlacePhotoServiceSpy: FetchPlacePhotoServiceSpy) {
        let fetchPlacePhotoServiceSpy = FetchPlacePhotoServiceSpy()
        let sut = PhotoViewModel(fetchPlacePhotoService: fetchPlacePhotoServiceSpy)
        return (sut, fetchPlacePhotoServiceSpy)
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
