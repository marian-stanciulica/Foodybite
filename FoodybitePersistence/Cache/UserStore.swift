//
//  UserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

public protocol UserStore {
    func read<T: LocalModelConvertable>() async throws -> T
    func write<T: LocalModelConvertable>(_ user: T) async throws
}
