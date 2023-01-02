//
//  ResourceLoaderSpy.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
@testable import FoodybitePlaces

class ResourceLoaderSpy: ResourceLoader {
    private let response: Decodable
    var requests = [URLRequest]()
    
    init(response: Decodable) {
        self.response = response
    }
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        requests.append(urlRequest)
        return response as! T
    }
}
