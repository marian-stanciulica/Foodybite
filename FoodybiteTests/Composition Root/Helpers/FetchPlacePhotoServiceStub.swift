//
//  FetchPlacePhotoServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import Foundation
import Domain

final class FetchPlacePhotoServiceStub: FetchPlacePhotoService {
    private(set) var capturedValues = [String]()
    var stub: Result<Data, Error>?
    
    func fetchPlacePhoto(photoReference: String) async throws -> Data {
        capturedValues.append(photoReference)
        
        if let stub = stub {
            return try stub.get()
        }
        
        return Data()
    }
}
