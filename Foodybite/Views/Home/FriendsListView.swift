//
//  FriendsListView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct FriendsListView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HeaderView(
            name: "Friends",
            allItemsCount: 56
        )

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(0...50, id: \.self) { index in
                    Image("profile_picture_test")
                        .resizable()
                        .frame(
                            width: width,
                            height: height
                        )
                        .cornerRadius(32)
                }
            }
        }
        .frame(maxHeight: 64)
        .padding(.horizontal)
    }
}
