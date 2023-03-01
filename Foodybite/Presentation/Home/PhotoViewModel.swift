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
    }
    
    private let fetchPhotoService: FetchPlacePhotoService
    
    @Published public var fetchPhotoState: State = .isLoading

    public init(fetchPhotoService: FetchPlacePhotoService) {
        self.fetchPhotoService = fetchPhotoService
    }
    
    public func fetchPhoto() async {
        fetchPhotoState = .failure
    }
}
