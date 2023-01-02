//
//  AutocompletePrediction.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct AutocompletePrediction: Decodable, Equatable {
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
    }
}
