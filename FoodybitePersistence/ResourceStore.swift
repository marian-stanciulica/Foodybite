//
//  ResourceStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

public protocol ResourceStore {
    associatedtype T
    
    func read() async throws -> T
    func write(_ object: T) async throws
    func delete(_ type: T.Type) async throws
}
