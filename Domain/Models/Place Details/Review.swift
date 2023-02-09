//
//  Review.swift
//  Domain
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation

public struct Review: Equatable, Identifiable {
    public var id: UUID
    public let placeID: String
    public let profileImageURL: URL?
    public let profileImageData: Data?
    public let authorName: String
    public let reviewText: String
    public let rating: Int
    public let relativeTime: String
    
    public init(id: UUID = UUID(), placeID: String, profileImageURL: URL?, profileImageData: Data?, authorName: String, reviewText: String, rating: Int, relativeTime: String) {
        self.id = id
        self.placeID = placeID
        self.profileImageURL = profileImageURL
        self.profileImageData = profileImageData
        self.authorName = authorName
        self.reviewText = reviewText
        self.rating = rating
        self.relativeTime = relativeTime
    }
    
    public static func ==(lhs: Review, rhs: Review) -> Bool {
        lhs.placeID == rhs.placeID &&
        lhs.profileImageURL == rhs.profileImageURL &&
        lhs.profileImageData == rhs.profileImageData &&
        lhs.authorName == rhs.authorName &&
        lhs.reviewText == rhs.reviewText &&
        lhs.rating == rhs.rating &&
        lhs.relativeTime == rhs.relativeTime
    }
}
