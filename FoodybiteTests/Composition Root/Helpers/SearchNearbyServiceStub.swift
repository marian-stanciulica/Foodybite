//
//  SearchNearbyServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

final class SearchNearbyServiceStub: SearchNearbyService {
    var stub: Result<[NearbyPlace], Error>?
    
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        if let stub = stub {
            return try stub.get()
        }
        
        return []
    }
}
