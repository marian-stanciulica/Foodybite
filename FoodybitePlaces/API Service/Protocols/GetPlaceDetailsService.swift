//
//  GetPlaceDetailsService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

protocol GetPlaceDetailsService {
    func getPlaceDetails(placeID: String) async throws -> PlaceDetails
}
