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
    
    func test_fetchPhoto_setsFetchPhotoStateToFailureWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, photoServiceSpy) = makeSUT()
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())

        photoServiceSpy.result = .failure(anyError())
        
        await sut.fetchPhoto()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .failure])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: PhotoViewModel, fetchPhotoServiceSpy: FetchPlacePhotoServiceSpy) {
        let fetchPhotoServiceSpy = FetchPlacePhotoServiceSpy()
        let sut = PhotoViewModel(fetchPhotoService: fetchPhotoServiceSpy)
        return (sut, fetchPhotoServiceSpy)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
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
