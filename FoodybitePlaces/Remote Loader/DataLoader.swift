//
//  DataLoader.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

public protocol DataLoader {
    func getData(for urlRequest: URLRequest) async throws -> Data
}
