//
//  RatingStar.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RatingStar: View {
    let rating: String
    let backgroundColor: Color
    
    var body: some View {
        HStack {
            Image("rating_yellow_star", bundle: .current)
                .resizable()
                .frame(width: 16, height: 16)

            Text(rating)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            backgroundColor.clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
        )
    }
}

struct RatingStar_Previews: PreviewProvider {
    static var previews: some View {
        RatingStar(rating: "3.4", backgroundColor: .gray)
    }
}
