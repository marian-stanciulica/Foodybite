//
//  RatingView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct RatingView: View {
    @State var stars: Int = 0
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Button {
                    stars = index
                } label: {
                    Image(index > stars ? "rating_gray_star" : "rating_yellow_star")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
        }
        .padding()
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
