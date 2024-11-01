//
//  CoreDataLocalStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Domain
@preconcurrency import CoreData

public final class CoreDataLocalStore: LocalStore {
    private let context: NSManagedObjectContext

    private struct CacheMissError: Error {}

    public init(storeURL: URL, bundle: Bundle = .init(for: CoreDataLocalStore.self)) throws {
        let container = try NSPersistentContainer.load(modelName: "Store", bundle: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    public func read<T: LocalModelConvertable>() async throws -> T {
        if let firstObject: T = try await readAll().first {
            return firstObject
        }

        throw CacheMissError()
    }

    public func readAll<T: LocalModelConvertable>() async throws -> [T] {
        try await context.perform {
            let request = T.LocalModel.fetchRequest()

            if let results = try self.context.fetch(request) as? [T.LocalModel] {
                return results.map { T(from: $0) }
            } else {
                throw CacheMissError()
            }
        }
    }

    public func write<T: LocalModelConvertable>(_ object: T) async throws {
        try await context.perform {
            let local = object.toLocalModel(context: self.context)
            self.context.insert(local)
            try self.context.save()
        }
    }

    public func writeAll<T: LocalModelConvertable>(_ objects: [T]) async throws {
        for object in objects {
            try await write(object)
        }
    }
}
