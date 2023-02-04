//
//  NewReviewView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 31.05.2022.
//

import SwiftUI

struct NewReviewView: View {
    @Binding var currentPage: Page
    @Binding var plusButtonActive: Bool
    
    @State var review = ""
    @State var restaurantSearch = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    withAnimation {
                        currentPage = .home
                        plusButtonActive = false
                    }
                }
                .foregroundColor(.gray)
                
                Spacer()
                
                Text("New Review")
                    .font(.title)
                
                Spacer()
                
                Button("Post") {
                    
                }
                .foregroundColor(.gray)
            }
            .padding()
            
            TextField("Search Restaurant", text: $restaurantSearch)
                .padding()
                .foregroundColor(.white)
                .overlay(
                     RoundedRectangle(cornerRadius: 16)
                         .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                )
                .padding()
        
            Text("Ratings")
                .font(.title)
            
            RatingView(stars: .constant(3))
                .frame(maxWidth: 300)
            
            Text("Rate your experience")
                .font(.title3)
                .foregroundColor(.gray)
                .padding()
            
            Text("Review")
                .font(.title)
                .padding(.top)
            
            VStack {
                TextField("Write your experience", text: $review)
                    .padding()
                
                Spacer()
            }
            .frame(height: 150)
            .overlay(
                 RoundedRectangle(cornerRadius: 16)
                     .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NewReviewView(
            currentPage: .constant(.home),
            plusButtonActive: .constant(true)
        )
    }
}
