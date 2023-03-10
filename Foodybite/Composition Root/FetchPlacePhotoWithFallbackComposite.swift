//
//  FetchPlacePhotoWithFallbackComposite.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import Foundation
import Domain

public final class FetchPlacePhotoWithFallbackComposite: FetchPlacePhotoService {
    private let primary: FetchPlacePhotoService
    private let secondary: FetchPlacePhotoService
    
    public init(primary: FetchPlacePhotoService, secondary: FetchPlacePhotoService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func fetchPlacePhoto(photoReference: String) async throws -> Data {
        do {
            return try await primary.fetchPlacePhoto(photoReference: photoReference)
        } catch {
            return try await secondary.fetchPlacePhoto(photoReference: photoReference)
        }
    }
}
