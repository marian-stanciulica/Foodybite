//
//  LocalStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

public protocol LocalStore: Sendable {
    func read<T: LocalModelConvertable>() async throws -> T
    func readAll<T: LocalModelConvertable>() async throws -> [T]
    func write<T: LocalModelConvertable>(_ object: T) async throws
    func writeAll<T: LocalModelConvertable>(_ objects: [T]) async throws
}
