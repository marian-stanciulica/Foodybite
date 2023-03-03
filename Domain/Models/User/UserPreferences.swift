//
//  UserPreferences.swift
//  Domain
//
//  Created by Marian Stanciulica on 03.03.2023.
//

public struct UserPreferences: Equatable {
    public let radius: Int
    public let starsNumber: Int
    
    public static let `default` = UserPreferences(radius: 1000, starsNumber: 0)
    
    public init(radius: Int, starsNumber: Int) {
        self.radius = radius
        self.starsNumber = starsNumber
    }
}
