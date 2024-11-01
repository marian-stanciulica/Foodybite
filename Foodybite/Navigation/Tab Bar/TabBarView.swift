//
//  TabBarView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct TabBarView: View {
    @Binding var plusButtonActive: Bool
    @Binding var currentPage: TabRouter.Page

    let tabBarWidth: CGFloat
    let tabBarHeight: CGFloat

    let iconWidth: CGFloat
    let iconHeight: CGFloat

    var body: some View {
        ZStack {
            HStack {
                makeTabBarIcon(assignedPage: .home)

                makeNewReviewTabBarIcon()
                .offset(y: -tabBarHeight / 4)
                .onTapGesture {
                    withAnimation {
                        plusButtonActive.toggle()

                        if currentPage != .newReview {
                            currentPage = .newReview
                        } else {
                            currentPage = .home
                        }
                    }
                }

                makeTabBarIcon(assignedPage: .account)
            }
            .frame(width: tabBarWidth, height: tabBarHeight / 2)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(Color("tabBarBackground"))
            )
        }
        .frame(width: tabBarWidth, height: tabBarHeight)
    }

    @ViewBuilder private func makeTabBarIcon(assignedPage: TabRouter.Page) -> some View {
        Spacer()
        TabBarIcon(currentPage: $currentPage,
                   assignedPage: assignedPage,
                   width: iconWidth,
                   height: iconHeight)
        Spacer()
    }

    private func makeNewReviewTabBarIcon() -> some View {
        ZStack {
            Circle()
                .shadow(
                    color: .marineBlue.opacity(0.5),
                    radius: 5,
                    x: 0,
                    y: 4
                )
                .frame(
                    width: iconWidth * 0.8,
                    height: iconWidth * 0.8
                )
                .foregroundColor(.marineBlue)

            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: iconWidth * 0.3,
                    height: iconWidth * 0.3
                )
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: plusButtonActive ? 135 : 0))
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(plusButtonActive: .constant(false),
                   currentPage: .constant(.home),
                   tabBarWidth: UIScreen.screenWidth,
                   tabBarHeight: UIScreen.screenHeight / 6,
                   iconWidth: UIScreen.screenWidth / 5,
                   iconHeight: UIScreen.screenHeight / 32)

        .padding()
        .background(.gray.opacity(0.2))
    }
}
