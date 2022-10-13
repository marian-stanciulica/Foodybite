//
//  RatingStar.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct RatingStar: View {
    var body: some View {
        HStack {
            Image("rating_yellow_star")
                .resizable()
                .frame(width: 16, height: 16)

            Text("4.5")
                .font(.caption)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.gray.opacity(0.1))
        )
    }
}

struct RatingStar_Previews: PreviewProvider {
    static var previews: some View {
        RatingStar()
    }
}
