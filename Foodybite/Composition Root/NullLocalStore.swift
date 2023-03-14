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

extension NullLocalStore: FetchPlacePhotoService {
    func fetchPlacePhoto(photoReference: String) async throws -> Data {
        throw CacheMissError()
    }
}

extension NullLocalStore: PlacePhotoCache {
    func save(photoData: Data, for photoReference: String) async throws {
        throw CacheMissError()
    }
}