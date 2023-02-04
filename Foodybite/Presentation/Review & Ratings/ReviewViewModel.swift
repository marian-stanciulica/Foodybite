//
//  ReviewViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation
import FoodybiteNetworking

public final class ReviewViewModel: ObservableObject {
    public enum State: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded
    }
    
    private let reviewService: ReviewService
    private let placeID: String
    
    @Published public var state: State = .idle
    public var reviewText = ""
    public var starsNumber = 0
    
    public init(placeID: String, reviewService: ReviewService) {
        self.placeID = placeID
        self.reviewService = reviewService
    }
    
    public func addReview() async {
        state = .isLoading
        
        do {
            try await reviewService.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber)
            state = .requestSucceeeded
        } catch {
            state = .loadingError("Review couldn't be posted. Try again!")
        }
    }
}
