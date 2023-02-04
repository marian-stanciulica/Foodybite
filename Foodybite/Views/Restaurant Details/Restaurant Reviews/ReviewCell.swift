//
//  ReviewCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import DomainModels
import SwiftUI

struct ReviewCell: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: review.profileImageURL)
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.authorName)
                            .font(.title2)
                            .padding(.bottom, 4)
                        
                        Spacer()
                        
                        RatingStar(
                            rating: "\(review.rating)",
                            backgroundColor: .gray.opacity(0.1)
                        )
                    }
                    
                    Text(review.relativeTime)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
            }
            
            Text(review.reviewText)
                .foregroundColor(.gray)
                .font(.callout)
            
            RoundedRectangle(cornerRadius: 0.1)
                .frame(maxHeight: 1)
                .foregroundColor(.gray.opacity(0.2))
        }
        .padding(.horizontal)
    }
}

struct ReviewCell_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCell(
            review: Review(
                profileImageURL: URL(string: "www.google.com"),
                profileImageData: nil,
                authorName: "Marian",
                reviewText: "Loren ipsum dolor sit amet, consec tetur adipiscing elit, sed do eiusmo temp cididunt ut labore et dolor magna aliqua. Ut enim ad mini veniam quis",
                rating: 2,
                relativeTime: "5 months ago"
            )
        )
    }
}
