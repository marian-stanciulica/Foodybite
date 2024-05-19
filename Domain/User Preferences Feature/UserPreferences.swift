//
//  UserPreferences.swift
//  Domain
//
//  Created by Marian Stanciulica on 03.03.2023.
//

public struct UserPreferences: Equatable, Sendable {
    public let radius: Int
    public let starsNumber: Int

    public static let `default` = UserPreferences(radius: 10_000, starsNumber: 0)

    public init(radius: Int, starsNumber: Int) {
        self.radius = radius
        self.starsNumber = starsNumber
    }
}
