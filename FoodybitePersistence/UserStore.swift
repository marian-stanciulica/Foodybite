//
//  UserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

#warning("Create a local User model and delete the import")
import DomainModels

public protocol UserStore {
    func read() async throws -> User
    func write(_ user: User) async throws
    func delete() async throws
}
