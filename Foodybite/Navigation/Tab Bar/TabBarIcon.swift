//
//  TabBarIcon.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteUI

struct TabBarIcon: View {
    @Binding var currentPage: Page
    let assignedPage: Page
    
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            Image(self.getImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        }
        .padding(.horizontal, -8)
        .onTapGesture {
            currentPage = assignedPage
        }
        .foregroundColor(currentPage == assignedPage ? .marineBlue : .gray)
    }
    
    private func getImage() -> String {
        switch assignedPage {
        case .home:
            return currentPage == assignedPage ? "home_active" : "home_inactive"
        case .account:
            return currentPage == assignedPage ? "account_active" : "account_inactive"
        case .newReview:
            return ""
        }
    }
}
