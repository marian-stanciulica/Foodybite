//
//  ResourceSender.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 29.03.2023.
//

import Foundation

public protocol ResourceSender: Sendable {
    func post(to urlRequest: URLRequest) async throws
}
