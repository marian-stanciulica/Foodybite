//
//  PlacePhotoCache.swift
//  Domain
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import Foundation

public protocol PlacePhotoCache {
    func save(photoData: Data, for photoReference: String) async throws
}
