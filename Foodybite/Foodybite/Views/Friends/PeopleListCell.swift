//
//  PeopleListCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct PeopleListCell: View {
    @Binding var accountType: AccountType

    var body: some View {
        HStack {
            Image("profile_picture_test")
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(32)

            VStack(alignment: .leading) {
                Text("Jayson Acevedo")
                    .font(.title2)
                    .padding(.bottom, 4)

                Text("50 Rated Restaurant")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            .padding(.horizontal, 2)

            Spacer()

            switch accountType {
            case .following:
                WhiteButton(title: "Unfollow") {

                }
                .frame(width: 110)
                .padding(.vertical)
            case .follower:
                MarineButton(title: "Follow") {

                }
                .frame(width: 110)
                .padding(.vertical)
            }
        }
    }
}

struct PeopleListCell_Previews: PreviewProvider {
    static var previews: some View {
        PeopleListCell(accountType: .constant(.following))
    }
}
