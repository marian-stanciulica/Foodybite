//
//  AutocompletePrediction.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct AutocompletePrediction: Decodable, Equatable {
    let placeID: String
    let placeName: String

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case nameContainer = "structured_formatting"
    }
    
    enum NameCodingKeys: String, CodingKey {
        case placeName = "main_text"
    }
    
    public init(placeID: String, placeName: String) {
        self.placeID = placeID
        self.placeName = placeName
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.placeID = try container.decode(String.self, forKey: .placeID)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .nameContainer)
        self.placeName = try nameContainer.decode(String.self, forKey: .placeName)
    }
}
