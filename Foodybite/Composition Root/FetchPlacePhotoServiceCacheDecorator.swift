//
//  FetchPlacePhotoServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import Foundation
import Domain

public final class FetchPlacePhotoServiceCacheDecorator: FetchPlacePhotoService {
    private let fetchPlacePhotoService: FetchPlacePhotoService
    private let cache: PlacePhotoCache
    
    public init(fetchPlacePhotoService: FetchPlacePhotoService, cache: PlacePhotoCache) {
        self.fetchPlacePhotoService = fetchPlacePhotoService
        self.cache = cache
    }
    
    public func fetchPlacePhoto(photoReference: String) async throws -> Data {
        let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: photoReference)
        try? await cache.save(photoData: photoData, for: photoReference)
        return photoData
    }
}
