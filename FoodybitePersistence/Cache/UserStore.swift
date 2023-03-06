//
//  UserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

public protocol UserStore {
    associatedtype LocalModel
    
    func read() async throws -> LocalModel
    func write(_ user: LocalModel) async throws
    func delete() async throws
}
