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
    var data: Data?
    var getRequests = [URLRequest]()
    var getDataRequests = [URLRequest]()
    
    init(response: Decodable) {
        self.response = response
    }
    
    func get<T>(for urlRequest: URLRequest) async throws -> T where T : Decodable {
        getRequests.append(urlRequest)
        return response as! T
    }
    
    func getData(for urlRequest: URLRequest) async throws -> Data {
        getDataRequests.append(urlRequest)
        return data ?? Data()
    }
}
