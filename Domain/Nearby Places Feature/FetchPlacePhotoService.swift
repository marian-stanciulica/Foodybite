//
//  FetchPlacePhotoService.swift
//  Domain
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import Foundation

public protocol FetchPlacePhotoService {
    func fetchPlacePhoto(photoReference: String) async throws -> Data
}
