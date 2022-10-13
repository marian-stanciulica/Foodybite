//
//  ReviewView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct ReviewView: View {
    @State var review: String
    
    var body: some View {
        VStack {
            Text("Review & Ratings")
                .font(.title)
            
            RatingView()
                .padding()
            
            Text("Rate your experience")
                .foregroundColor(.gray)
                .padding()
            
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
            
            Spacer()
            
            MarineButton(title: "Done") {
                
            }
        }
        .padding()
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(review: "")
    }
}