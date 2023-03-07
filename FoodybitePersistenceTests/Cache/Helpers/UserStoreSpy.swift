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

    func read<T: LocalModelConvertable>() async throws -> T {
        messages.append(.read)
        
        if let readCompletion = readResult {
            return try readCompletion.get() as! T
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
    
    func write<T: LocalModelConvertable>(_ user: T) async throws {
        messages.append(.write)
        writeParameter = (user as! User)
        
        if let writeError = writeError {
            throw writeError
        }
    }
    
    func setWrite(error: Error?) {
        writeError = error
    }
}
