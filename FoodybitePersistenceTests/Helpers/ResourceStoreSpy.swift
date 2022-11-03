//
//  ResourceStoreSpy.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import Foundation
import FoodybitePersistence

class ResourceStoreSpy<T>: ResourceStore {
    enum Message {
        case read
        case write
        case delete
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    private(set) var readResult: Result<T, Error>?
    
    private(set) var writeError: Error? = nil
    private(set) var writeParameter: T?

    private(set) var deleteError: Error? = nil
    
    func read() async throws -> T {
        messages.append(.read)
        
        if let readCompletion = readResult {
            return try readCompletion.get()
        } else {
            throw CompletionNotSet()
        }
    }
    
    func setRead(error: Error) {
        readResult = .failure(error)
    }
    
    func setRead(returnedObject object: T) {
        readResult = .success(object)
    }
    
    func write(_ object: T) async throws {
        messages.append(.write)
        writeParameter = object
        
        if let writeError = writeError {
            throw writeError
        }
    }
    
    func setWrite(error: Error?) {
        writeError = error
    }
    
    func delete(_ type: T.Type) async throws {
        messages.append(.delete)
        
        if let deleteError = deleteError {
            throw deleteError
        }
    }
    
    func setDeletion(error: Error?) {
        deleteError = error
    }
}
