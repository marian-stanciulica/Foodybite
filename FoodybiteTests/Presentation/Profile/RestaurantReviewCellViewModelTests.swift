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
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    
    @Published public var getPlaceDetailsState: State = .isLoading
    
    init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    func getPlaceDetails() async {
        do {
            _ = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
        } catch {
            getPlaceDetailsState = .loadingError("An error occured while fetching review details. Please try again later!")
        }
    }
}

final class RestaurantReviewCellViewModelTests: XCTestCase {
    
    func test_init_stateIsLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .isLoading)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let anyPlaceID = anyPlaceID()
        let (sut, getPlaceDetailsServiceSpy) = makeSUT(placeID: anyPlaceID)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
    }
    
    func test_getPlaceDetails_setsStateToLoadingErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy) = makeSUT()
        getPlaceDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .loadingError("An error occured while fetching review details. Please try again later!")])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeID: String = "") -> (sut: RestaurantReviewCellViewModel,
                               getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let sut = RestaurantReviewCellViewModel(placeID: placeID, getPlaceDetailsService: getPlaceDetailsServiceSpy)
        return (sut, getPlaceDetailsServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
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
    
}
