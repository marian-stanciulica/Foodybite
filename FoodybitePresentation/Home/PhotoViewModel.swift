//
//  PhotoViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import Foundation
import Domain

public final class PhotoViewModel: ObservableObject {
    public enum Error: Swift.Error {
        case serverError
    }

    public enum State: Equatable {
        case isLoading
        case failure
        case noImageAvailable
        case success(Data)
    }

    private let photoReference: String?
    private let restaurantPhotoService: RestaurantPhotoService

    @Published public var fetchPhotoState: State = .isLoading

    public init(photoReference: String?, restaurantPhotoService: RestaurantPhotoService) {
        self.photoReference = photoReference
        self.restaurantPhotoService = restaurantPhotoService
    }

    @MainActor public func fetchPhoto() async {
        guard let photoReference = photoReference else {
            fetchPhotoState = .noImageAvailable
            return
        }

        do {
            let imageData = try await restaurantPhotoService.fetchPhoto(photoReference: photoReference)
            fetchPhotoState = .success(imageData)
        } catch {
            fetchPhotoState = .failure
        }
    }
}
