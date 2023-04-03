//
//  EmptyFetchPlacePhotoService.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Foundation
import Domain

class EmptyRestaurantPhotoService: RestaurantPhotoService {
    func fetchPhoto(photoReference: String) async throws -> Data {
        Data()
    }
}
