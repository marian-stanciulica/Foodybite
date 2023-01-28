//
//  FoodybitePlacesAPIEndToEndTests.swift
//  FoodybiteAPIEndToEndTests
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import XCTest
import DomainModels
import FoodybitePlaces

final class FoodybitePlacesAPIEndToEndTests: XCTestCase {

    func test_endToEndSearchNearby_matchesFixedTestNearbyPlaces() async {
        do {
            let receivedNearbyPlaces = try await getNearbyPlaces()
            XCTAssertEqual(receivedNearbyPlaces, expectedNearbyPlaces)
        } catch {
            XCTFail("Expected successful nearby places request, got \(error) instead")
        }
    }
    
    func test_endToEndGetPlaceDetails_matchesFixedTestPlaceDetails() async {
        do {
            let receivedPlaceDetails = try await getPlaceDetails()
            XCTAssertEqual(receivedPlaceDetails, expectedPlaceDetails)
        } catch {
            XCTFail("Expected successful nearby places request, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> APIService {
        let httpClient = URLSessionHTTPClient()
        let loader = RemoteResourceLoader(client: httpClient)
        return APIService(loader: loader)
    }
    
    private func getPlaceDetails(file: StaticString = #filePath, line: UInt = #line) async throws -> PlaceDetails {
        let apiService = makeSUT(file: file, line: line)
        return try await apiService.getPlaceDetails(placeID: "ChIJLyIrrb2vEmsRbYMRvZkU1yo")
    }
    
    private func getNearbyPlaces(file: StaticString = #filePath, line: UInt = #line) async throws -> [NearbyPlace] {
        let apiService = makeSUT(file: file, line: line)
        let location = Location(latitude: 44.439663, longitude: 26.096306)
        let radius = 100
        return try await apiService.searchNearby(location: location, radius: radius)
    }
    
    private var expectedNearbyPlaces: [NearbyPlace] {
        [
            NearbyPlace(placeID: "ChIJ9ZCzFzGuEmsR_EwB_qra-W4", placeName: "BLACK Bar & Grill"),
            NearbyPlace(placeID: "ChIJ1-v38TauEmsRNrXszdcSywQ", placeName: "The Century by Golden Century"),
            NearbyPlace(placeID: "ChIJ77Cd7TauEmsRBV42CMtSans", placeName: "24/7 Sports Bar"),
            NearbyPlace(placeID: "ChIJLyIrrb2vEmsRbYMRvZkU1yo", placeName: "Rumble"),
            NearbyPlace(placeID: "ChIJE8QpKg6vEmsRS6kStkd1sB8", placeName: "Mashi No Mashi")
        ]
    }
    
    private var expectedPlaceDetails: PlaceDetails {
        PlaceDetails(name: "Rumble")
    }

}
