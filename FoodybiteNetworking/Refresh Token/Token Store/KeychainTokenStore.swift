//
//  KeychainTokenStore.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Foundation

public class KeychainTokenStore: TokenStore {
    private let service: String
    private let account: String
    private let codableDataParser = CodableDataParser()
    
    private enum Error: Swift.Error {
        case notFound
        case invalidData
        case writeFailed
        case deleteFailed
    }
    
    public init(service: String = "store", account: String = "token") {
        self.service = service
        self.account = account
    }
    
    public func read() throws -> AuthToken {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        guard let data = result as? Data else {
            throw Error.notFound
        }
        
        guard let token: AuthToken = try codableDataParser.decode(data: data) else {
            throw Error.invalidData
        }
        
        return token
    }
    
    public func write(_ token: AuthToken) throws {
        let data = try codableDataParser.encode(item: token)
        
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary

        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as [CFString : Any] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        } else if status != errSecSuccess {
            throw Error.writeFailed
        }
    }
    
    public func delete() throws {
        let query = [
                kSecAttrService: service as AnyObject,
                kSecAttrAccount: account as AnyObject,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
        let status = SecItemDelete(query)

        guard status == errSecSuccess else {
            throw Error.deleteFailed
        }
    }
}
