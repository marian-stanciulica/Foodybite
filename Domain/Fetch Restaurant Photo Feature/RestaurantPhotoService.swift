//
//  RestaurantPhotoService.swift
//  Domain
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import Foundation

public protocol RestaurantPhotoService {
    func fetchPhoto(photoReference: String) async throws -> Data
}
