//
//  NewReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import Testing
import Foundation.NSData
import Domain
import FoodybitePresentation

struct NewReviewViewModelTests {

    @Test func init_stateIsIdle() {
        let (sut, _, _, _) = makeSUT()

        #expect(sut.getRestaurantDetailsState == .idle)
        #expect(sut.postReviewState == .idle)
        #expect(sut.searchText == "")
        #expect(sut.reviewText == "")
        #expect(sut.starsNumber == 0)
    }

    @Test func autocomplete_sendsParametersCorrectlyToAutocompleteRestaurantsService() async {
        let location = anyLocation()
        let userPreferences = anyUserPreferences()
        let (sut, autocompleteSpy, _, _) = makeSUT(location: location, userPreferences: userPreferences)
        sut.searchText = anySearchText()

        await sut.autocomplete()

        #expect(autocompleteSpy.capturedValues.count == 1)
        #expect(autocompleteSpy.capturedValues.first?.input == anySearchText())
        #expect(autocompleteSpy.capturedValues.first?.location == location)
        #expect(autocompleteSpy.capturedValues.first?.radius == userPreferences.radius)
    }

    @Test func autocomplete_setsResultsToEmptyWhenAutocompleteRestaurantsServiceThrowsError() async {
        let (sut, autocompleteSpy, _, _) = makeSUT()
        autocompleteSpy.result = .failure(anyError())

        #expect(sut.autocompleteResults.isEmpty == true)

        await sut.autocomplete()
        #expect(sut.autocompleteResults.isEmpty == true)
    }

    @Test func autocomplete_setsResultsToReceivedResultsWhenAutocompleteRestaurantsServiceReturnsSuccessfully() async {
        let (sut, autocompleteSpy, _, _) = makeSUT()
        let expectedResults = anyAutocompletePredictions()

        autocompleteSpy.result = .success(expectedResults)
        await sut.autocomplete()
        #expect(sut.autocompleteResults == expectedResults)

        autocompleteSpy.result = .failure(anyError())
        await sut.autocomplete()
        #expect(sut.autocompleteResults.isEmpty == true)
    }

    @Test func autocomplete_resetsStateForRestaurantDetails() async {
        let (sut, _, _, _) = makeSUT()
        sut.getRestaurantDetailsState = .isLoading

        await sut.autocomplete()

        #expect(sut.getRestaurantDetailsState == .idle)
    }

    @Test func getRestaurantDetails_sendsInputsToRestaurantDetailsService() async {
        let (sut, _, restaurantDetailsServiceSpy, _) = makeSUT()
        let anyRestaurantID = anyRestaurantID()

        await sut.getRestaurantDetails(restaurantID: anyRestaurantID)

        #expect(restaurantDetailsServiceSpy.capturedValues.count == 1)
        #expect(restaurantDetailsServiceSpy.capturedValues.first == anyRestaurantID)
    }

    @Test func getRestaurantDetails_setsGetRestaurantDetailsStateToLoadingErrorWhenRestaurantDetailsServiceThrowsError() async {
        let (sut, _, restaurantDetailsServiceSpy, _) = makeSUT()
        restaurantDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getRestaurantDetailsState.eraseToAnyPublisher())

        await sut.getRestaurantDetails(restaurantID: anyRestaurantID())

        #expect(stateSpy.results == [.idle, .isLoading, .failure(.serverError)])
    }

    @Test func getRestaurantDetails_setsGetRestaurantDetailsStateToRequestSucceeededWhenRestaurantDetailsServiceReturnsSuccessfully() async {
        let (sut, _, restaurantDetailsServiceSpy, _) = makeSUT()
        let expectedRestaurantDetails = anyRestaurantDetails()
        restaurantDetailsServiceSpy.result = .success(expectedRestaurantDetails)
        let stateSpy = PublisherSpy(sut.$getRestaurantDetailsState.eraseToAnyPublisher())

        await sut.getRestaurantDetails(restaurantID: anyRestaurantID())

        #expect(stateSpy.results == [.idle, .isLoading, .success(expectedRestaurantDetails)])
    }

    @Test func postReviewEnabled_isTrueWhenRestaurantDetailsExistsStarsAreNotZeroAndReviewIsNotEmpty() async {
        let (sut, _, _, _) = makeSUT()
        #expect(!sut.postReviewEnabled)

        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())
        #expect(!sut.postReviewEnabled)

        sut.starsNumber = 3
        #expect(!sut.postReviewEnabled)

        sut.reviewText = anyReviewText()
        #expect(sut.postReviewEnabled)

        sut.getRestaurantDetailsState = .idle
        #expect(!sut.postReviewEnabled)

        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())
        sut.starsNumber = 0
        #expect(!sut.postReviewEnabled)

        sut.starsNumber = 3
        sut.reviewText = ""
        #expect(!sut.postReviewEnabled)
    }

    @Test func postReview_isGuardedByPostReviewEnabled() async {
        let (sut, _, _, reviewServiceSpy) = makeSUT()

        await sut.postReview()
        #expect(reviewServiceSpy.capturedValues.isEmpty)

        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())
        await sut.postReview()
        #expect(reviewServiceSpy.capturedValues.isEmpty)

        sut.starsNumber = 3
        await sut.postReview()
        #expect(reviewServiceSpy.capturedValues.isEmpty)

        sut.reviewText = anyReviewText()
        await sut.postReview()
        #expect(!reviewServiceSpy.capturedValues.isEmpty)
    }

    @Test func postReview_sendsParametersCorrectlyToAddReviewService() async {
        let (sut, _, _, reviewServiceSpy) = makeSUT()
        let anyRestaurantDetails = anyRestaurantDetails()
        sut.getRestaurantDetailsState = .success(anyRestaurantDetails)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()

        await sut.postReview()

        #expect(reviewServiceSpy.capturedValues.count == 1)
        #expect(reviewServiceSpy.capturedValues.first?.restaurantID == anyRestaurantDetails.id)
        #expect(reviewServiceSpy.capturedValues.first?.reviewText == anyReviewText())
        #expect(reviewServiceSpy.capturedValues.first?.starsNumber == anyStarsNumber())
    }

    @Test func postReview_setsStateToLoadingErrorWhenAddReviewServiceThrowsError() async {
        let (sut, _, _, reviewServiceSpy) = makeSUT()
        sut.getRestaurantDetailsState = .success(anyRestaurantDetails())
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()

        reviewServiceSpy.error = anyError()
        let stateSpy = PublisherSpy(sut.$postReviewState.eraseToAnyPublisher())

        await sut.postReview()

        #expect(stateSpy.results == [.idle, .isLoading, .failure(.serverError)])
    }

    @Test func postReview_resetsStateForAllPublishedVariablesWhenReviewPostedSuccessfully() async {
        let (sut, _, _, _) = makeSUT()
        let restaurantDetails = anyRestaurantDetails()
        sut.getRestaurantDetailsState = .success(restaurantDetails)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()

        let postReviewState = PublisherSpy(sut.$postReviewState.eraseToAnyPublisher())
        let getRestaurantDetailsState = PublisherSpy(sut.$getRestaurantDetailsState.eraseToAnyPublisher())

        await sut.postReview()

        #expect(sut.reviewText.isEmpty)
        #expect(sut.starsNumber == 0)
        #expect(postReviewState.results == [.idle, .isLoading, .idle])
        #expect(getRestaurantDetailsState.results == [.success(restaurantDetails), .idle])
    }

    // MARK: - Helpers

    private func makeSUT(location: Location? = nil, userPreferences: UserPreferences? = nil) -> (
        sut: NewReviewViewModel,
        autocompleteSpy: AutocompleteRestaurantsServiceSpy,
        restaurantDetailsServiceSpy: RestaurantDetailsServiceSpy,
        addReviewServiceSpy: AddReviewServiceSpy
    ) {
        let autocompleteSpy = AutocompleteRestaurantsServiceSpy()
        let restaurantDetailsServiceSpy = RestaurantDetailsServiceSpy()
        let addReviewServiceSpy = AddReviewServiceSpy()

        let defaultLocation = Location(latitude: 0, longitude: 0)
        let sut = NewReviewViewModel(
            autocompleteRestaurantsService: autocompleteSpy,
            restaurantDetailsService: restaurantDetailsServiceSpy,
            addReviewService: addReviewServiceSpy,
            location: location ?? defaultLocation,
            userPreferences: userPreferences ?? .default
        )
        return (sut, autocompleteSpy, restaurantDetailsServiceSpy, addReviewServiceSpy)
    }

    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }

    private func anyRestaurantID() -> String {
        "any restaurant id"
    }

    private func anyLocation() -> Location {
        Location(latitude: 44.439663, longitude: 26.096306)
    }

    private func anyUserPreferences() -> UserPreferences {
        UserPreferences(radius: 200, starsNumber: 4)
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
            AutocompletePrediction(restaurantPrediction: "restaurant prediction #1", restaurantID: "restaurant id #1"),
            AutocompletePrediction(restaurantPrediction: "restaurant prediction #2", restaurantID: "restaurant id #2"),
            AutocompletePrediction(restaurantPrediction: "restaurant prediction #3", restaurantID: "restaurant id #3")
        ]
    }

    private func anyRestaurantDetails() -> RestaurantDetails {
        RestaurantDetails(
            id: "restaurant #1",
            phoneNumber: "+61 2 9374 4000",
            name: "restaurant name",
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
                    "Sunday: Closed"
                ]
            ),
            reviews: [
                Review(
                    restaurantID: "restaurant #1",
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

    private class AutocompleteRestaurantsServiceSpy: AutocompleteRestaurantsService {
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

    private class RestaurantDetailsServiceSpy: RestaurantDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<RestaurantDetails, Error>?

        func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
            capturedValues.append(restaurantID)

            if let result = result {
                return try result.get()
            }

            return RestaurantDetails(id: "restaurant #1",
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

    private class AddReviewServiceSpy: AddReviewService {
        private(set) var capturedValues = [(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date)]()
        var error: Error?

        func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
            capturedValues.append((restaurantID, reviewText, starsNumber, createdAt))

            if let error = error {
                throw error
            }
        }
    }

}
