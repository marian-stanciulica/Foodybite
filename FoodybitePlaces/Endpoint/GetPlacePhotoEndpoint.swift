//
//  GetPlacePhotoEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation

public struct GetPlacePhotoEndpoint: Endpoint {
    private let photoReference: String
    
    init(photoReference: String) {
        self.photoReference = photoReference
    }
    
    var path: String {
        "/maps/api/place/photo"
    }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "photo_reference", value: photoReference),
            URLQueryItem(name: "maxwidth", value: "400")
        ]
    }
}