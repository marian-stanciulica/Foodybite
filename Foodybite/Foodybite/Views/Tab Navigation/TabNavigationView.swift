//
//  TabNavigationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct TabNavigationView: View {
    @StateObject var viewRouter: ViewRouter
        
    @State var plusButtonActive = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .home:
                    HomeView()
                case .favorites:
                    LoginView()
                        .background(.red)
                case .notifications:
                    RegisterView()
                        .background(.yellow)
                case .account:
                    TurnOnLocationView()
                        .background(.pink)
                }
                Spacer()
                
                TabBarView(plusButtonActive: $plusButtonActive,
                           viewRouter: viewRouter,
                           tabBarWidth: geometry.size.width,
                           tabBarHeight: geometry.size.height / 6,
                           iconWidth: geometry.size.width / 5,
                           iconHeight: geometry.size.height / 32)
                .background(.gray.opacity(0.1))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView(viewRouter: ViewRouter())
    }
}
