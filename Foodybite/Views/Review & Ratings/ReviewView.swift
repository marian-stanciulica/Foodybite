//
//  ReviewView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI
import FoodybiteNetworking

struct ReviewView: View {
    @StateObject var viewModel: ReviewViewModel
    let dismissScreen: () -> Void
    
    var body: some View {
        VStack {
            Text("Review & Ratings")
                .font(.title)
            
            RatingView(stars: $viewModel.starsNumber)
                .padding()
            
            Text("Rate your experience")
                .foregroundColor(.gray)
                .padding()
            
            VStack {
                TextField("Write your experience", text: $viewModel.reviewText)
                    .padding()
                
                Spacer()
            }
            .frame(height: 150)
            .overlay(
                 RoundedRectangle(cornerRadius: 16)
                     .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
            
            Spacer()
            
            MarineButton(title: "Done") {
                Task {
                    await viewModel.addReview()
                }
            }
        }
        .padding()
        .arrowBackButtonStyle()
        .onChange(of: viewModel.state) { state in
            guard state == .requestSucceeeded else { return }
            
            dismissScreen()
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReviewView(viewModel: ReviewViewModel(placeID: "any place id", reviewService: PreviewReviewService()), dismissScreen: {})
        }
    }
    
    private class PreviewReviewService: ReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws {}
    }
}
