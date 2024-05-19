//
//  OpeningHoursDetails.swift
//  Domain
//
//  Created by Marian Stanciulica on 28.01.2023.
//

public struct OpeningHoursDetails: Equatable, Hashable, Sendable {
    public let openNow: Bool
    public let weekdayText: [String]

    public init(openNow: Bool, weekdayText: [String]) {
        self.openNow = openNow
        self.weekdayText = weekdayText
    }
}
