//
//  NullLocalStore.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import Foundation
import Domain
import FoodybitePersistence

final class NullLocalStore: LocalStore {
    private struct CacheMissError: Error {}

    func read<T: LocalModelConvertable>() async throws -> T {
        throw CacheMissError()
    }
    
    func readAll<T: LocalModelConvertable>() async throws -> [T] {
        throw CacheMissError()
    }
    
    func write<T: LocalModelConvertable>(_ user: T) async throws {
        throw CacheMissError()
    }
    
    func writeAll<T: LocalModelConvertable>(_ objects: [T]) async throws {
        throw CacheMissError()
    }
}

extension NullLocalStore: GetReviewsService {
    func getReviews(placeID: String?) async throws -> [Review] {
        []
    }
}

extension NullLocalStore: ReviewsCache {
    func save(reviews: [Review]) async throws {}
}
