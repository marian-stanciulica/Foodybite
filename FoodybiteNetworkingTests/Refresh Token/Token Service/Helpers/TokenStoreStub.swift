//
//  TokenStoreStub.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

@testable import FoodybiteNetworking
import Foundation

class TokenStoreStub: TokenStore {
    private var stub: AuthToken?
    
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
        stub = token
    }
}
