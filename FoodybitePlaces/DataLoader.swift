//
//  DataLoader.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 29.03.2023.
//

import Foundation

public protocol DataLoader: Sendable {
    func getData(for urlRequest: URLRequest) async throws -> Data
}
