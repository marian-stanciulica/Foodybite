//
//  EmptyFetchPlacePhotoService.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Foundation
import Domain

class EmptyPlacePhotoService: RestaurantPhotoService {
    func fetchPhoto(photoReference: String) async throws -> Data {
        Data()
    }
}
