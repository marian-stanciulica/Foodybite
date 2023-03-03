//
//  LocalUserPreferences.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Domain

public struct LocalUserPreferences: Codable {
    public let radius: Int
    public let starsNumber: Int
    
    public func toDomain() -> UserPreferences {
        UserPreferences(radius: radius, starsNumber: starsNumber)
    }
}

extension UserPreferences {
    func toLocal() -> LocalUserPreferences {
        LocalUserPreferences(radius: radius, starsNumber: starsNumber)
    }
}
