//
//  SearchNearbyServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

final class SearchNearbyServiceStub: SearchNearbyService {
    private(set) var capturedValues = [(location: Location, radius: Int)]()
    var stub: Result<[NearbyPlace], Error>?
    
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        capturedValues.append((location, radius))
        
        if let stub = stub {
            return try stub.get()
        }
        
        return []
    }
}
