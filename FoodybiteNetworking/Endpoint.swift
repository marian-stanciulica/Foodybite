//
//  Endpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: RequestType { get }
    var headers: [String: String] { get }
    var body: [String: String] { get }
    var urlParams: [String: String] { get }
}
