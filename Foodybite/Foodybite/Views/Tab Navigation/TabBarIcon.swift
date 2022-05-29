//
//  TabBarIcon.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct TabBarIcon: View {
    @StateObject var viewRouter: ViewRouter
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
            viewRouter.currentPage = assignedPage
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? .marineBlue : .gray)
    }
    
    private func getImage() -> String {
        switch assignedPage {
        case .home:
            return viewRouter.currentPage == assignedPage ? "home_active" : "home_inactive"
        case .favorites:
            return viewRouter.currentPage == assignedPage ? "favorites_active" : "favorites_inactive"
        case .notifications:
            return viewRouter.currentPage == assignedPage ? "notifications_active" : "notifications_inactive"
        case .account:
            return viewRouter.currentPage == assignedPage ? "account_active" : "account_inactive"
        }
    }
}
