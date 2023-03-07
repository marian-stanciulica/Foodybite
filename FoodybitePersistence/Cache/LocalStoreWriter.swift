//
//  LocalStoreWriter.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

public protocol LocalStoreWriter {
    func write<T: LocalModelConvertable>(_ object: T) async throws
}
