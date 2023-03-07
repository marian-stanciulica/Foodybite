//
//  ResourceStoreSpy.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import Foundation
import Domain
import FoodybitePersistence

class UserStoreSpy: UserStore {
    enum Message {
        case read
        case write
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    private(set) var readResult: Result<User, Error>?
    
    private(set) var writeError: Error? = nil
    private(set) var writeParameter: User?

    func read() async throws -> User {
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
    
    func setRead(returnedObject object: User) {
        readResult = .success(object)
    }
    
    func write(_ user: User) async throws {
        messages.append(.write)
        writeParameter = user
        
        if let writeError = writeError {
            throw writeError
        }
    }
    
    func setWrite(error: Error?) {
        writeError = error
    }
}
