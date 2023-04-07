//
//  PhotoViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import XCTest
import Domain
import FoodybitePresentation

final class PhotoViewModelTests: XCTestCase {

    func test_init_fetchPhotoStateIsLoading() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.fetchPhotoState, .isLoading)
    }

    func test_fetchPhoto_sendsPhotoReferenceToRestaurantPhotoService() async {
        let photoReference = "photo reference"
        let (sut, photoServiceSpy) = makeSUT(photoReference: photoReference)

        await sut.fetchPhoto()

        XCTAssertEqual(photoServiceSpy.capturedValues, [photoReference])
    }

    func test_fetchPhoto_setsFetchPhotoStateToNoImageAvailableWhenPhotoReferenceIsNil() async {
        let (sut, _) = makeSUT(photoReference: nil)

        await assert(on: sut, expectedResult: .noImageAvailable)
    }

    func test_fetchPhoto_setsFetchPhotoStateToFailureWhenRestaurantPhotoServiceThrowsError() async {
        let (sut, photoServiceSpy) = makeSUT()
        photoServiceSpy.result = .failure(anyError())

        await assert(on: sut, expectedResult: .failure)
    }

    func test_fetchPhoto_setsFetchPhotoStateToSuccessWhenRestaurantPhotoServiceReturnsSuccessfully() async {
        let (sut, photoServiceSpy) = makeSUT()
        let expectedData = anyData()
        photoServiceSpy.result = .success(expectedData)

        await assert(on: sut, expectedResult: .success(expectedData))
    }

    // MARK: - Helpers

    private func makeSUT(photoReference: String? = "photo reference") -> (sut: PhotoViewModel, fetchPhotoServiceSpy: RestaurantPhotoServiceSpy) {
        let fetchPhotoServiceSpy = RestaurantPhotoServiceSpy()
        let sut = PhotoViewModel(photoReference: photoReference, restaurantPhotoService: fetchPhotoServiceSpy)
        return (sut, fetchPhotoServiceSpy)
    }

    private func assert(on sut: PhotoViewModel,
                        expectedResult: PhotoViewModel.State,
                        file: StaticString = #filePath,
                        line: UInt = #line) async {
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())

        await sut.fetchPhoto()

        XCTAssertEqual(stateSpy.results, [.isLoading, expectedResult], file: file, line: line)
    }

    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }

    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }

    private class RestaurantPhotoServiceSpy: RestaurantPhotoService {
        var result: Result<Data, Error>?
        private(set) var capturedValues = [String]()

        func fetchPhoto(photoReference: String) async throws -> Data {
            capturedValues.append(photoReference)

            if let result = result {
                return try result.get()
            }

            return Data()
        }
    }

}
