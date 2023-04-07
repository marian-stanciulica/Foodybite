//
//  RemotePhoto.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import Foundation
import Domain

struct RemotePhoto: Decodable {
    let width: Int
    let height: Int
    let photoReference: String

    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }

    var model: Photo {
        Photo(width: width, height: height, photoReference: photoReference)
    }
}
