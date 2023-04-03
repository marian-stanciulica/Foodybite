//
//  RemoteReview.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation
import Domain

struct RemoteReview: Decodable {
    let id = UUID()
    let restaurantID: String
    let profileImageData: Data?
    let authorName: String
    let reviewText: String
    let rating: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case restaurantID
        case profileImageData
        case authorName
        case reviewText
        case rating
        case createdAt
    }
    
    var review: Review {
        let formatter = RelativeDateTimeFormatter()

        return Review(
            id: id,
            restaurantID: restaurantID,
            profileImageURL: nil,
            profileImageData: profileImageData,
            authorName: authorName,
            reviewText: reviewText,
            rating: rating,
            relativeTime: formatter.localizedString(for: createdAt, relativeTo: Date())
        )
    }
}
