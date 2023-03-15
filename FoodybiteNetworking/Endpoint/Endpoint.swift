//
//  Endpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation
import SharedAPI

extension Endpoint {
    var scheme: String {
        "http"
    }
    
    var port: Int? {
        8080
    }
    
    var host: String {
        "localhost"
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
