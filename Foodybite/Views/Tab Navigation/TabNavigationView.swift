//
//  TabNavigationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking

struct TabNavigationView: View {
    @StateObject var tabRouter: TabRouter
    @State var plusButtonActive = false
    let apiService: APIService
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Group {
                    switch tabRouter.currentPage {
                    case .home:
                        HomeView()
                    case .newReview:
                        NewReviewView(currentPage: $tabRouter.currentPage, plusButtonActive: $plusButtonActive)
                    case .account:
                        ProfileFlowView(flow: ProfileFlow(), apiService: apiService)
                    }
                }
                
                Spacer()
                
                TabBarView(plusButtonActive: $plusButtonActive,
                           currentPage: $tabRouter.currentPage,
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

//struct TabNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabNavigationView(tabRouter: TabRouter())
//    }
//}
