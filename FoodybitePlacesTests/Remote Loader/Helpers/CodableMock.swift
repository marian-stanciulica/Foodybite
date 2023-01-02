//
//  CodableMock.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

struct CodableArrayMock: Codable, Equatable {
    let mocks: [CodableMock]
}

struct CodableMock: Codable, Equatable {
    let name: String
    let password: String
}
