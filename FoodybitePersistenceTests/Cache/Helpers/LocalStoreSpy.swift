//
//  LocalStoreSpy.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import Foundation
import Domain
import FoodybitePersistence

class LocalStoreSpy: LocalStoreReader, LocalStoreWriter {
    enum Message {
        case read
        case readAll
        case write(any LocalModelConvertable)
        case writeAll([any LocalModelConvertable])
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    var readResult: Result<any LocalModelConvertable, Error>?
    var readAllResult: Result<[any LocalModelConvertable], Error>?

    func read<T: LocalModelConvertable>() async throws -> T {
        messages.append(.read)
        
        if let result = readResult {
            return try result.get() as! T
        } else {
            throw CompletionNotSet()
        }
    }
    
    func readAll<T: LocalModelConvertable>() async throws -> [T] {
        messages.append(.readAll)
        
        if let result = readAllResult {
            return try result.get() as! [T]
        } else {
            throw CompletionNotSet()
        }
    }
    
    func write<T: LocalModelConvertable>(_ object: T) async throws {
        messages.append(.write(object))
    }
    
    func writeAll<T: LocalModelConvertable>(_ objects: [T]) async throws {
        messages.append(.writeAll(objects))
    }
}
