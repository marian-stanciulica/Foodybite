//
//  RatingView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct RatingView: View {
    @Binding var stars: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Button {
                    stars = index
                } label: {
                    Image("rating_yellow_star", bundle: .current)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(index > stars ? Color.gray.opacity(0.5) : Color.yellow)
                        .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.gray.opacity(0.2))
        )
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(stars: .constant(2))
    }
}
