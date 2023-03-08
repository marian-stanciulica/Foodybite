//
//  GetPlaceDetailsDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class GetPlaceDetailsDAO: GetPlaceDetailsService {
    private let store: LocalStoreReader & LocalStoreWriter

    private struct CacheMissError: Error {}

    public init(store: LocalStoreReader & LocalStoreWriter) {
        self.store = store
    }
    
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let allPlaces: [PlaceDetails] = try await store.readAll()
        
        guard let foundPlace = allPlaces.first(where: { $0.placeID == placeID }) else {
            throw CacheMissError()
        }
        
        return foundPlace
    }
}
