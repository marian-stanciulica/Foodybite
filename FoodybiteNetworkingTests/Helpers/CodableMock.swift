//
//  CodableMock.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

struct CodableArrayMock: Codable, Equatable {
    let mocks: [CodableMock]
}

struct CodableMock: Codable, Equatable {
    let name: String
    let password: String
}
