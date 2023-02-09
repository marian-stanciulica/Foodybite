//
//  RemoteReview.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation

struct RemoteReview: Codable {
    let id = UUID()
    let placeID: String
    let profileImageData: Data?
    let authorName: String
    let reviewText: String
    let rating: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case placeID
        case profileImageData
        case authorName
        case reviewText
        case rating
        case createdAt
    }
}
