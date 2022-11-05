//
//  ResourceStoreSpy.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import Foundation
import FoodybitePersistence

class UserStoreSpy: UserStore {
    enum Message {
        case read
        case write
        case delete
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    private(set) var readResult: Result<LocalUser, Error>?
    
    private(set) var writeError: Error? = nil
    private(set) var writeParameter: LocalUser?

    private(set) var deleteError: Error? = nil
    
    func read() async throws -> LocalUser {
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
    
    func setRead(returnedObject object: LocalUser) {
        readResult = .success(object)
    }
    
    func write(_ user: LocalUser) async throws {
        messages.append(.write)
        writeParameter = user
        
        if let writeError = writeError {
            throw writeError
        }
    }
    
    func setWrite(error: Error?) {
        writeError = error
    }
    
    func delete() async throws {
        messages.append(.delete)
        
        if let deleteError = deleteError {
            throw deleteError
        }
    }
    
    func setDeletion(error: Error?) {
        deleteError = error
    }
}
