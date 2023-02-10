//
//  NewReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import XCTest
import Domain

final class NewReviewViewModel: ObservableObject {
    public enum State<T>: Equatable where T: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded(T)
    }
    
    private let autocompletePlacesService: AutocompletePlacesService
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPlacePhotoService: FetchPlacePhotoService
    private let addReviewService: AddReviewService
    private let location: Location
    
    @Published public var getPlaceDetailsState: State<PlaceDetails> = .idle
    @Published public var fetchPhotoState: State<Data> = .idle
    
    public var searchText = ""
    public var reviewText = ""
    public var starsNumber = 0
    public var autocompleteResults = [AutocompletePrediction]()
    
    public var postReviewEnabled: Bool {
        if case .requestSucceeeded = getPlaceDetailsState {
            return !reviewText.isEmpty && starsNumber > 0
        }
        return false
    }
    
    init(autocompletePlacesService: AutocompletePlacesService, getPlaceDetailsService: GetPlaceDetailsService, fetchPlacePhotoService: FetchPlacePhotoService, addReviewService: AddReviewService, location: Location) {
        self.autocompletePlacesService = autocompletePlacesService
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPlacePhotoService = fetchPlacePhotoService
        self.addReviewService = addReviewService
        self.location = location
    }
    
    func autocomplete() async {
        getPlaceDetailsState = .idle
        fetchPhotoState = .idle
        
        do {
            autocompleteResults = try await autocompletePlacesService.autocomplete(input: searchText, location: location, radius: 100)
        } catch {
            autocompleteResults = []
        }
    }
    
    func getPlaceDetails(placeID: String) async {
        getPlaceDetailsState = .isLoading
        
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
            getPlaceDetailsState = .requestSucceeeded(placeDetails)
            
            if let firstPhoto = placeDetails.photos.first {
                await fetchPhoto(firstPhoto)
            }
        } catch {
            getPlaceDetailsState = .loadingError("An error occured while fetching place details. Please try again later!")
        }
    }
    
    private func fetchPhoto(_ photo: Photo) async {
        fetchPhotoState = .isLoading
        
        do {
            let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
            fetchPhotoState = .requestSucceeeded(photoData)
        } catch {
            fetchPhotoState = .loadingError("An error occured while fetching place photo. Please try again later!")
        }
    }
    
    func postReview() async {
        guard postReviewEnabled else { return }
        
        if case let .requestSucceeeded(placeDetails) = getPlaceDetailsState {
            try? await addReviewService.addReview(
                placeID: placeDetails.placeID,
                reviewText: reviewText,
                starsNumber: starsNumber,
                createdAt: Date())
        }
    }
}

final class NewReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _, _, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .idle)
        XCTAssertEqual(sut.fetchPhotoState, .idle)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_autocomplete_sendsParametersCorrectlyToAutocompletePlacesService() async {
        let anyLocation = anyLocation()
        let radius = 100
        let (sut, autocompleteSpy, _, _, _) = makeSUT(location: anyLocation)
        sut.searchText = anySearchText()
        
        await sut.autocomplete()
        
        XCTAssertEqual(autocompleteSpy.capturedValues.count, 1)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.input, anySearchText())
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.location, anyLocation)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.radius, radius)
    }
    
    func test_autocomplete_setsResultsToEmptyWhenAutocompletePlacesServiceThrowsError() async {
        let (sut, autocompleteSpy, _, _, _) = makeSUT()
        autocompleteSpy.result = .failure(anyError())
        
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
        
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_autocomplete_setsResultsToReceivedResultsWhenAutocompletePlacesServiceReturnsSuccessfully() async {
        let (sut, autocompleteSpy, _, _, _) = makeSUT()
        let expectedResults = anyAutocompletePredictions()
        
        autocompleteSpy.result = .success(expectedResults)
        await sut.autocomplete()
        XCTAssertEqual(sut.autocompleteResults, expectedResults)
        
        autocompleteSpy.result = .failure(anyError())
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_autocomplete_resetsStateForPlaceDetailsAndPlacePhoto() async {
        let (sut, _, _, _, _) = makeSUT()
        sut.getPlaceDetailsState = .isLoading
        sut.fetchPhotoState = .isLoading

        await sut.autocomplete()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .idle)
        XCTAssertEqual(sut.fetchPhotoState, .idle)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let (sut, _, getPlaceDetailsServiceSpy, _, _) = makeSUT()
        let anyPlaceID = anyPlaceID()
        
        await sut.getPlaceDetails(placeID: anyPlaceID)
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateToLoadingErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, _, getPlaceDetailsServiceSpy, _, _) = makeSUT()
        getPlaceDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .loadingError("An error occured while fetching place details. Please try again later!")])
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateToRequestSucceeededWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, _, getPlaceDetailsServiceSpy, _, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .requestSucceeeded(expectedPlaceDetails)])
    }
    
    func test_getPlaceDetails_triggersFetchPhoto() async {
        let (sut, _, getPlaceDetailsServiceSpy, photoServiceSpy, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        
        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(photoServiceSpy.capturedValues.first, expectedPlaceDetails.photos.first?.photoReference)
    }
    
    func test_fetchPhoto_setsFetchPhotoStateToLoadingErrorWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, _, getPlaceDetailsServiceSpy, photoServiceSpy, _) = makeSUT()
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())

        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails())
        photoServiceSpy.result = .failure(anyError())
        
        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .loadingError("An error occured while fetching place photo. Please try again later!")])
    }
    
    func test_fetchPhoto_setsFetchPhotoStateToRequestSucceeededWhenFetchPlacePhotoServiceThrowsError() async {
        let (sut, _, getPlaceDetailsServiceSpy, photoServiceSpy, _) = makeSUT()
        let stateSpy = PublisherSpy(sut.$fetchPhotoState.eraseToAnyPublisher())
        let expectedData = anyData()
        
        getPlaceDetailsServiceSpy.result = .success(anyPlaceDetails())
        photoServiceSpy.result = .success(expectedData)
        
        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .requestSucceeeded(expectedData)])
    }
    
    func test_postReviewEnabled_isTrueWhenPlaceDetailsExistsStarsAreNotZeroAndReviewIsNotEmpty() async {
        let (sut, _, _, _, _) = makeSUT()
        XCTAssertFalse(sut.postReviewEnabled)
        
        sut.getPlaceDetailsState = .requestSucceeeded(anyPlaceDetails())
        XCTAssertFalse(sut.postReviewEnabled)

        sut.starsNumber = 3
        XCTAssertFalse(sut.postReviewEnabled)

        sut.reviewText = anyReviewText()
        XCTAssertTrue(sut.postReviewEnabled)
        
        sut.getPlaceDetailsState = .idle
        XCTAssertFalse(sut.postReviewEnabled)

        sut.getPlaceDetailsState = .requestSucceeeded(anyPlaceDetails())
        sut.starsNumber = 0
        XCTAssertFalse(sut.postReviewEnabled)
        
        sut.starsNumber = 3
        sut.reviewText = ""
        XCTAssertFalse(sut.postReviewEnabled)
    }
    
    func test_postReview_isGuardedByPostReviewEnabled() async {
        let (sut, _, _, _, reviewServiceSpy) = makeSUT()

        await sut.postReview()
        XCTAssertTrue(reviewServiceSpy.capturedValues.isEmpty)
        
        sut.getPlaceDetailsState = .requestSucceeeded(anyPlaceDetails())
        await sut.postReview()
        XCTAssertTrue(reviewServiceSpy.capturedValues.isEmpty)
        
        sut.starsNumber = 3
        await sut.postReview()
        XCTAssertTrue(reviewServiceSpy.capturedValues.isEmpty)
        
        sut.reviewText = anyReviewText()
        await sut.postReview()
        XCTAssertFalse(reviewServiceSpy.capturedValues.isEmpty)
    }
    
    func test_postReview_sendsParametersCorrectlyToAddReviewService() async {
        let (sut, _, _, _, reviewServiceSpy) = makeSUT()
        let anyPlaceDetails = anyPlaceDetails()
        sut.getPlaceDetailsState = .requestSucceeeded(anyPlaceDetails)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()
        
        await sut.postReview()
        
        XCTAssertEqual(reviewServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.placeID, anyPlaceDetails.placeID)
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.reviewText, anyReviewText())
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.starsNumber, anyStarsNumber())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(location: Location? = nil) -> (
        sut: NewReviewViewModel,
        autocompleteSpy: AutocompletePlacesServiceSpy,
        getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy,
        fetchPlacePhotoServiceSpy: FetchPlacePhotoServiceSpy,
        addReviewServiceSpy: AddReviewServiceSpy
    ) {
        let autocompleteSpy = AutocompletePlacesServiceSpy()
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let fetchPlacePhotoServiceSpy = FetchPlacePhotoServiceSpy()
        let addReviewServiceSpy = AddReviewServiceSpy()

        let defaultLocation = Location(latitude: 0, longitude: 0)
        let sut = NewReviewViewModel(
            autocompletePlacesService: autocompleteSpy,
            getPlaceDetailsService: getPlaceDetailsServiceSpy,
            fetchPlacePhotoService: fetchPlacePhotoServiceSpy,
            addReviewService: addReviewServiceSpy,
            location: location ?? defaultLocation
        )
        return (sut, autocompleteSpy, getPlaceDetailsServiceSpy, fetchPlacePhotoServiceSpy, addReviewServiceSpy)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyLocation() -> Location {
        Location(latitude: 44.439663, longitude: 26.096306)
    }
    
    private func anySearchText() -> String {
        "any search text"
    }
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyAutocompletePredictions() -> [AutocompletePrediction] {
        [
            AutocompletePrediction(placePrediction: "place prediction #1", placeID: "place id #1"),
            AutocompletePrediction(placePrediction: "place prediction #2", placeID: "place id #2"),
            AutocompletePrediction(placePrediction: "place prediction #3", placeID: "place id #3")
        ]
    }
    
    private func anyPlaceDetails() -> PlaceDetails {
        PlaceDetails(
            placeID: "place #1",
            phoneNumber: "+61 2 9374 4000",
            name: "Place name",
            address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
            rating: 3.4,
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
                    placeID: "place #1",
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
    
    private func anyPhotos() -> [Photo] {
        [
            Photo(width: 100, height: 200, photoReference: "first photo reference"),
            Photo(width: 200, height: 300, photoReference: "second photo reference"),
            Photo(width: 300, height: 400, photoReference: "third photo reference")
        ]
    }
    
    private class AutocompletePlacesServiceSpy: AutocompletePlacesService {
        private(set) var capturedValues = [(input: String, location: Location, radius: Int)]()
        var result: Result<[AutocompletePrediction], Error>?
        
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
            capturedValues.append((input, location, radius))
            
            if let result = result {
                return try result.get()
            }
            
            return []
        }
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<PlaceDetails, Error>?
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return PlaceDetails(placeID: "place #1",
                                phoneNumber: nil,
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
    
    private class AddReviewServiceSpy: AddReviewService {
        private(set) var capturedValues = [(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date)]()
        var error: Error?
        
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
            capturedValues.append((placeID, reviewText, starsNumber, createdAt))
            
            if let error = error {
                throw error
            }
        }
    }
    
}
