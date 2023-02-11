//
//  SelectedRestaurantViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.02.2023.
//

import XCTest
import Domain

final class SelectedRestaurantViewModel {
    public enum State: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded(Data)
    }
    
    private let placeDetails: PlaceDetails
    private let fetchPlacePhotoService: FetchPlacePhotoService
    
    public var placeName: String {
        placeDetails.name
    }
    
    public var placeAddress: String {
        placeDetails.address
    }
    
    @Published public var fetchPhotoState: State = .idle
    
    init(placeDetails: PlaceDetails, fetchPlacePhotoService: FetchPlacePhotoService) {
        self.placeDetails = placeDetails
        self.fetchPlacePhotoService = fetchPlacePhotoService
    }
    
    public func fetchPhoto() async {
        fetchPhotoState = .isLoading
        
        guard let firstPhoto = placeDetails.photos.first else {
            fetchPhotoState = .loadingError("This place has no photos!")
            return
        }
        
        do {
            let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: firstPhoto.photoReference)
            fetchPhotoState = .requestSucceeeded(photoData)
        } catch {
            fetchPhotoState = .loadingError("An error occured while fetching place photo. Please try again later!")
        }
    }
}

final class SelectedRestaurantViewModelTests: XCTestCase {
    
    func test_placeName_equalsPlaceName() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.placeName, anyPlaceName())
    }
    
    func test_placeAddress_equalsPlaceAddress() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.placeAddress, anyPlaceAddress())
    }
    
    func test_fetchPhoto_setsStateToLoadingErrorWhenPlaceDetailsDoesNotHaveAnyPhotos() async {
        let (sut, _) = makeSUT(placeDetails: anyPlaceDetails())
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())
        
        await sut.fetchPhoto()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .loadingError("This place has no photos!")])
    }
    
    func test_fetchPhoto_sendsInputsToFetchPlacePhotoService() async {
        let placeDetails = anyPlaceDetails(photos: [anyPhoto()])
        let (sut, serviceSpy) = makeSUT(placeDetails: placeDetails)

        await sut.fetchPhoto()

        XCTAssertEqual(serviceSpy.capturedValues.first, anyPhoto().photoReference)
    }
    
    func test_fetchPhoto_setsStateToLoadingErrorWhenFetchPlacePhotoServiceThrowsError() async {
        let placeDetails = anyPlaceDetails(photos: [anyPhoto()])
        let (sut, serviceSpy) = makeSUT(placeDetails: placeDetails)
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())
        
        serviceSpy.result = .failure(anyError)
        await sut.fetchPhoto()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .loadingError("An error occured while fetching place photo. Please try again later!")])
    }
    
    func test_fetchPhoto_updatesImageDataWhenFetchPlacePhotoServiceReturnsSuccessfully() async {
        let placeDetails = anyPlaceDetails(photos: [anyPhoto()])
        let (sut, serviceSpy) = makeSUT(placeDetails: placeDetails)
        let expectedData = anyData()
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())

        serviceSpy.result = .success(expectedData)
        await sut.fetchPhoto()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .requestSucceeeded(expectedData)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeDetails: PlaceDetails? = nil) -> (sut: SelectedRestaurantViewModel, fetchPlacePhotoServiceSpy: FetchPlacePhotoServiceSpy) {
        let fetchPlacePhotoServiceSpy = FetchPlacePhotoServiceSpy()
        let defaultPlaceDetails = anyPlaceDetails()
        let sut = SelectedRestaurantViewModel(
            placeDetails: placeDetails ?? defaultPlaceDetails,
            fetchPlacePhotoService: fetchPlacePhotoServiceSpy
        )
        return (sut, fetchPlacePhotoServiceSpy)
    }
    
    private func anyPlaceName() -> String {
        "Place name"
    }
    
    private func anyPlaceAddress() -> String {
        "Place address"
    }
    
    private func anyPlaceDetails(photos: [Photo] = []) -> PlaceDetails {
        PlaceDetails(placeID: UUID().uuidString, phoneNumber: nil, name: anyPlaceName(), address: anyPlaceAddress(), rating: 0, openingHoursDetails: nil, reviews: [], location: Location(latitude: 0, longitude: 0), photos: photos)
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
