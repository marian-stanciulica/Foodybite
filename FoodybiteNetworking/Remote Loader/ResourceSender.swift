//
//  ResourceSender.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation

public protocol ResourceSender {
    func post(to urlRequest: URLRequest) async throws
}
