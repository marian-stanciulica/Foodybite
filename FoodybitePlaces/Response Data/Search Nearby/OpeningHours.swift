//
//  OpeningHours.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

struct OpeningHours: Decodable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}
