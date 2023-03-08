//
//  GetPlaceDetailsServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

final class GetPlaceDetailsServiceStub: GetPlaceDetailsService {
    private(set) var capturedValues = [String]()
    var stub: Result<PlaceDetails, Error>?
    
    private struct MissingStubError: Error {}
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        capturedValues.append(placeID)
        
        if let stub = stub {
            return try stub.get()
        }
        
        throw MissingStubError()
    }
}
