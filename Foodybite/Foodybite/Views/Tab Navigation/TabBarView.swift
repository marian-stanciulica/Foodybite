//
//  TabBarView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct TabBarView: View {
    @Binding var plusButtonActive: Bool
    
    let viewRouter: ViewRouter
    
    let tabBarWidth: CGFloat
    let tabBarHeight: CGFloat
    
    let iconWidth: CGFloat
    let iconHeight: CGFloat
    
    var body: some View {
        ZStack {
            HStack {
                TabBarIcon(viewRouter: viewRouter,
                           assignedPage: .home,
                           width: iconWidth,
                           height: iconHeight)
                
                TabBarIcon(viewRouter: viewRouter,
                           assignedPage: .favorites,
                           width: iconWidth,
                           height: iconHeight)
                
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
                .offset(y: -tabBarHeight / 4)
                .onTapGesture {
                    withAnimation {
                        plusButtonActive.toggle()
                    }
                }
                
                TabBarIcon(viewRouter: viewRouter,
                           assignedPage: .notifications,
                           width: iconWidth,
                           height: iconHeight)
                
                TabBarIcon(viewRouter: viewRouter,
                           assignedPage: .account,
                           width: iconWidth,
                           height: iconHeight)
            }
            .frame(width: tabBarWidth,height: tabBarHeight / 2)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(.white)
            )
        }
        .frame(width: tabBarWidth, height: tabBarHeight)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(plusButtonActive: .constant(false),
                    viewRouter: ViewRouter(),
                   tabBarWidth: UIScreen.screenWidth,
                   tabBarHeight: UIScreen.screenHeight / 6,
                   iconWidth: UIScreen.screenWidth / 5,
                   iconHeight: UIScreen.screenHeight / 32)
        
        
        .padding()
        .background(.gray.opacity(0.2))
    }
}
