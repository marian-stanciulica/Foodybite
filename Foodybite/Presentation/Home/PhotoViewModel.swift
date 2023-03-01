//
//  PhotoViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import Foundation
import Domain

public final class PhotoViewModel: ObservableObject {
    public enum State: Equatable {
        case isLoading
    }
    
    private let fetchPhotoService: FetchPlacePhotoService
    
    @Published public var fetchPhotoState: State = .isLoading

    public init(fetchPhotoService: FetchPlacePhotoService) {
        self.fetchPhotoService = fetchPhotoService
    }
}
