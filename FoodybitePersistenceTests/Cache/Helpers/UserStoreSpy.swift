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
        case readAll
        case write(User)
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    var readResult: Result<User, Error>?
    var readAllResult: Result<[User], Error>?
    var writeResult: Result<Void, Error>?

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
        messages.append(.write(object as! User))
        
        if let result = writeResult {
            return try result.get()
        }
    }
}
