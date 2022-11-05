//
//  UserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

public protocol UserStore {
    func read() async throws -> LocalUser
    func write(_ user: LocalUser) async throws
    func delete() async throws
}
