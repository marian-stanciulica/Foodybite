//
//  AutocompleteResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

struct AutocompleteResponse: Decodable {
    let predictions: [Prediction]
    let status: String
}

struct Prediction: Decodable {
    let description: String
    let matchedSubstrings: [MatchedSubstring]
    let placeID: String
    let reference: String
    let structuredFormatting: StructuredFormatting
    let terms: [Term]
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case description
        case matchedSubstrings = "matched_substrings"
        case placeID = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
        case terms, types
    }
}

struct MatchedSubstring: Decodable {
    let length, offset: Int
}

struct StructuredFormatting: Decodable {
    let placeName: String
    let mainTextMatchedSubstrings: [MatchedSubstring]
    let secondaryText: String

    enum CodingKeys: String, CodingKey {
        case placeName = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
    }
}

struct Term: Decodable {
    let offset: Int
    let value: String
}
