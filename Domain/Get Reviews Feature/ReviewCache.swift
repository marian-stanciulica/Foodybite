//
//  ReviewsCache.swift
//  Domain
//
//  Created by Marian Stanciulica on 14.03.2023.
//

public protocol ReviewCache: Sendable {
    func save(reviews: [Review]) async throws
}
