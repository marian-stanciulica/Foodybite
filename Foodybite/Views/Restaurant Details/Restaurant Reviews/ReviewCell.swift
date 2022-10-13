//
//  ReviewCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct ReviewCell: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("profile_picture_test")
                .resizable()
                .frame(width: 56, height: 56)
                .cornerRadius(28)

            VStack(alignment: .leading) {
                HStack {
                    Text("Jayson Acevedo")
                        .font(.title2)
                        .padding(.bottom, 4)

                    Spacer()

                    RatingStar()
                }

                Text("Loren ipsum dolor sit amet, consec tetur adipiscing elit, sed do eiusmo temp cididunt ut labore et dolor magna aliqua. Ut enim ad mini veniam quis")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            .padding(.horizontal)
        }
    }
}

struct ReviewCell_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCell()
    }
}
