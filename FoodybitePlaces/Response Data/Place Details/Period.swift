//
//  Period.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

struct Period: Decodable {
    let close: Close?
    let periodOpen: Close

    enum CodingKeys: String, CodingKey {
        case close
        case periodOpen = "open"
    }
}

struct Close: Decodable {
    let day: Int
    let time: String
}
