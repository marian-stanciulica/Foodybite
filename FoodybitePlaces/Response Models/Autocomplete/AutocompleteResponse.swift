//
//  AutocompleteResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

struct AutocompleteResponse: Codable {
    let predictions: [Prediction]
    let status: String
}

struct Prediction: Codable {
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

struct MatchedSubstring: Codable {
    let length, offset: Int
}

struct StructuredFormatting: Codable {
    let mainText: String
    let mainTextMatchedSubstrings: [MatchedSubstring]
    let secondaryText: String

    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
    }
}

struct Term: Codable {
    let offset: Int
    let value: String
}
