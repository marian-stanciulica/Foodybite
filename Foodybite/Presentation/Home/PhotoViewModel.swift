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
    private let fetchPhotoService: FetchPlacePhotoService
    
    @Published public var fetchPhotoState: State = .isLoading

    public init(photoReference: String?, fetchPhotoService: FetchPlacePhotoService) {
        self.photoReference = photoReference
        self.fetchPhotoService = fetchPhotoService
    }
    
    @MainActor public func fetchPhoto() async {
        guard let photoReference = photoReference else {
            fetchPhotoState = .noImageAvailable
            return
        }
        
        do {
            let imageData = try await fetchPhotoService.fetchPlacePhoto(photoReference: photoReference)
            fetchPhotoState = .success(imageData)
        } catch {
            fetchPhotoState = .failure
        }
    }
}
