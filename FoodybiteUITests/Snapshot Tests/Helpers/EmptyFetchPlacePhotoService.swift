//
//  EmptyFetchPlacePhotoService.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Foundation
import Domain

class EmptyFetchPlacePhotoService: FetchPlacePhotoService {
    func fetchPlacePhoto(photoReference: String) async throws -> Data {
        Data()
    }
}
