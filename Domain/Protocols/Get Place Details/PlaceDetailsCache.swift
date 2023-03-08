//
//  PlaceDetailsCache.swift
//  Domain
//
//  Created by Marian Stanciulica on 08.03.2023.
//

public protocol PlaceDetailsCache {
    func save(placeDetails: PlaceDetails) async throws
}
