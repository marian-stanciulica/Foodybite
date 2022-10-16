//
//  TokenStore.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 16.10.2022.
//

import Foundation

protocol TokenStore {
    func save(_ data: Data)
    func read() -> Data?
}
