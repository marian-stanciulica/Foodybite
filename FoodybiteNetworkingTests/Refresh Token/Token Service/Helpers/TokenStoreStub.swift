//
//  TokenStoreStub.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Foundation
import FoodybiteNetworking

class TokenStoreStub: TokenStore {
    private var stub: AuthToken?
    private(set) var writeCount = 0
    
    init() {}
    
    init(_ initialValue: AuthToken) {
        stub = initialValue
    }
    
    func read() throws -> AuthToken {
        guard let stub = stub else {
            throw NSError(domain: "any error", code: 1)
        }
        
        return stub
    }
    
    func write(_ token: AuthToken) throws {
        writeCount += 1
        stub = token
    }
    
    func delete() throws {
        stub = nil
    }
}
