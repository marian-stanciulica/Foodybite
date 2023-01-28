//
//  Review.swift
//  DomainModels
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation

public struct Review: Equatable, Identifiable {
    public var id = UUID()
    public let profileImageURL: URL
    public let authorName: String
    public let reviewText: String
    public let rating: Int
    public let relativeTime: String
    
    public init(profileImageURL: URL, authorName: String, reviewText: String, rating: Int, relativeTime: String) {
        self.profileImageURL = profileImageURL
        self.authorName = authorName
        self.reviewText = reviewText
        self.rating = rating
        self.relativeTime = relativeTime
    }
}
