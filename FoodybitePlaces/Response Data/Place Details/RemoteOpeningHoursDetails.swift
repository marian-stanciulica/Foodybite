//
//  RemoteOpeningHoursDetails.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Domain

struct RemoteOpeningHoursDetails: Decodable {
    let openNow: Bool
    let periods: [Period]
    let weekdayText: [String]

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case periods
        case weekdayText = "weekday_text"
    }
    
    var model: OpeningHoursDetails {
        OpeningHoursDetails(openNow: openNow, weekdayText: weekdayText)
    }
}
