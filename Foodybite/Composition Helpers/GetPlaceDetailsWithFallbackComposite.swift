//
//  GetPlaceDetailsWithFallbackComposite.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class GetPlaceDetailsWithFallbackComposite: GetPlaceDetailsService {
    private let primary: GetPlaceDetailsService
    private let secondary: GetPlaceDetailsService
    
    public init(primary: GetPlaceDetailsService, secondary: GetPlaceDetailsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        do {
            return try await primary.getPlaceDetails(placeID: placeID)
        } catch {
            return try await secondary.getPlaceDetails(placeID: placeID)
        }
    }
}
