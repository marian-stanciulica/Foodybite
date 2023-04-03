//
//  ReviewView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct ReviewView: View {
    @ObservedObject var viewModel: ReviewViewModel
    let dismissScreen: () -> Void
    
    public init(viewModel: ReviewViewModel, dismissScreen: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissScreen = dismissScreen
    }
    
    public var body: some View {
        VStack {
            Text("Review & Ratings")
                .font(.title)
            
            RatingView(stars: $viewModel.starsNumber)
                .padding()
            
            Text("Rate your experience")
                .foregroundColor(.gray)
                .padding()
            
            VStack {
                TextField("Write your experience", text: $viewModel.reviewText, axis: .vertical)
                    .padding()
                
                Spacer()
            }
            .frame(height: 150)
            .overlay(
                 RoundedRectangle(cornerRadius: 16)
                     .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
            
            Spacer()
            
            MarineButton(title: "Done", isLoading: viewModel.isLoading) {
                Task {
                    await viewModel.addReview()
                }
            }
            
            createFeedbackText()
        }
        .padding()
        .arrowBackButtonStyle()
        .onChange(of: viewModel.state) { state in
            guard state == .success else { return }
            
            dismissScreen()
        }
    }
    
    private func createFeedbackText() -> Text {
        if case let .failure(loginError) = viewModel.state {
            return Text(loginError.rawValue)
                .foregroundColor(.red)
                .font(.headline)
        }
        
        return Text("")
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReviewView(viewModel: ReviewViewModel(restaurantID: "any place id", reviewService: PreviewReviewService()), dismissScreen: {})
        }
    }
    
    private class PreviewReviewService: AddReviewService {
        func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
