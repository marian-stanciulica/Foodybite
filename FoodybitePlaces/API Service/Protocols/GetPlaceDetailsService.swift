//
//  GetPlaceDetailsService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import DomainModels

protocol GetPlaceDetailsService {
    func getPlaceDetails(placeID: String) async throws -> PlaceDetails
}
