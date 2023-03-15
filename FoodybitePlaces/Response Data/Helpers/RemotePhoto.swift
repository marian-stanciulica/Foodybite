//
//  RemotePhoto.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import Foundation

struct RemotePhoto: Decodable {
    let height: Int
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}
