//
//  RemoteReview.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

struct RemoteReview: Decodable {
    let authorName: String
    let authorURL: URL
    let language: String
    let profilePhotoURL: URL?
    let rating: Int
    let relativeTimeDescription, text: String
    let time: Int

    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case language
        case profilePhotoURL = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text, time
    }
}
