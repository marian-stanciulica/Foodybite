//
//  ReviewViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation
import Domain

public final class ReviewViewModel: ObservableObject {
    public enum AddReviewError: String, Error {
        case serverError = "Review couldn't be posted. Try again!"
    }
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(AddReviewError)
        case success
    }
    
    private let reviewService: AddReviewService
    private let restaurantID: String
    
    @Published public var state: State = .idle
    @Published public var reviewText = ""
    @Published public var starsNumber = 0
    
    public var isLoading: Bool {
        state == .isLoading
    }
    
    public init(restaurantID: String, reviewService: AddReviewService) {
        self.restaurantID = restaurantID
        self.reviewService = reviewService
    }
    
    @MainActor public func addReview() async {
        state = .isLoading
        
        do {
            try await reviewService.addReview(restaurantID: restaurantID, reviewText: reviewText, starsNumber: starsNumber, createdAt: Date())
            state = .success
        } catch {
            state = .failure(.serverError)
        }
    }
}
