//
//  RestaurantReviewCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import XCTest
import Domain

class RestaurantReviewCellViewModel: ObservableObject {
    enum State: Equatable {
        case isLoading
        case loadingError(String)
        case requestSucceeeded(PlaceDetails)
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPlacePhotoService: FetchPlacePhotoService
    
    @Published public var getPlaceDetailsState: State = .isLoading
    @Published public var getPlacePhotoState: State = .isLoading
    
    init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService, fetchPlacePhotoService: FetchPlacePhotoService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPlacePhotoService = fetchPlacePhotoService
    }
    
    func getPlaceDetails() async {
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
            getPlaceDetailsState = .requestSucceeeded(placeDetails)
            
            if let firstPhoto = placeDetails.photos.first {
                await fetchPhoto(firstPhoto)
            }
        } catch {
            getPlaceDetailsState = .loadingError("An error occured while fetching review details. Please try again later!")
        }
    }
    
    private func fetchPhoto(_ photo: Photo) async {
        do {
            _ = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
        } catch {
            getPlacePhotoState = .loadingError("An error occured while fetching place photo. Please try again later!")
        }
    }
}

final class RestaurantReviewCellViewModelTests: XCTestCase {
    
    func test_init_getPlaceDetailsStateIsLoading() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .isLoading)
    }
    
    func test_init_getPlacePhotoStateIsLoading() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlacePhotoState, .isLoading)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let anyPlaceID = anyPlaceID()
        let (sut, getPlaceDetailsServiceSpy, _) = makeSUT(placeID: anyPlaceID)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
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
    
    func test_fetchPhoto_setsGetPlacePhotoStateToLoadingErrorWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy, photoServiceSpy) = makeSUT()
        let stateSpy = PublisherSpy(sut.$getPlacePhotoState.eraseToAnyPublisher())

        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        photoServiceSpy.result = .failure(anyError())
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .loadingError("An error occured while fetching place photo. Please try again later!")])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeID: String = "") -> (sut: RestaurantReviewCellViewModel, getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy, fetchPlacePhotoServiceSpy: FetchPlacePhotoServiceSpy) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let fetchPlacePhotoServiceSpy = FetchPlacePhotoServiceSpy()
        let sut = RestaurantReviewCellViewModel(placeID: placeID, getPlaceDetailsService: getPlaceDetailsServiceSpy, fetchPlacePhotoService: fetchPlacePhotoServiceSpy)
        return (sut, getPlaceDetailsServiceSpy, fetchPlacePhotoServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
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
            
            return PlaceDetails(phoneNumber: nil,
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
