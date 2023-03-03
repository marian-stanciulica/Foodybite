//
//  UserPreferences.swift
//  Domain
//
//  Created by Marian Stanciulica on 03.03.2023.
//

public struct UserPreferences {
    let radius: Int
    let starsNumber: Int
    
    static let `default` = UserPreferences(radius: 1000, starsNumber: 0)
}
