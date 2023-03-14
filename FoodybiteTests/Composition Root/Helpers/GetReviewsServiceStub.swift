//
//  FetchPlacePhotoServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import Foundation
import Domain

final class GetReviewsServiceStub: GetReviewsService {
    private(set) var capturedValues = [String?]()
    var stub: Result<[Review], Error>?
    
    func getReviews(placeID: String?) async throws -> [Review] {
        capturedValues.append(placeID)
        
        if let stub = stub {
            return try stub.get()
        }
        
        return []
    }
}
