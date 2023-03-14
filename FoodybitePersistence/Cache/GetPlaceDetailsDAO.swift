//
//  GetPlaceDetailsDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class GetPlaceDetailsDAO: GetPlaceDetailsService, PlaceDetailsCache {
    private let store: LocalStore

    private struct CacheMissError: Error {}

    public init(store: LocalStore) {
        self.store = store
    }
    
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let allPlaces: [PlaceDetails] = try await store.readAll()
        
        guard let foundPlace = allPlaces.first(where: { $0.placeID == placeID }) else {
            throw CacheMissError()
        }
        
        return foundPlace
    }
    
    public func save(placeDetails: PlaceDetails) async throws {
        try await store.write(placeDetails)
    }
}
