//
//  AddressComponent.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

struct AddressComponent: Decodable {
    let longName: String
    let shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}
