//
//  TabNavigationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces

struct TabNavigationView: View {
    @StateObject var tabRouter: TabRouter
    @State var plusButtonActive = false
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Group {
                    switch tabRouter.currentPage {
                    case .home:
                        HomeView(viewModel: HomeViewModel(searchNearbyService: placesService))
                    case .newReview:
                        NewReviewView(currentPage: $tabRouter.currentPage, plusButtonActive: $plusButtonActive)
                    case .account:
                        ProfileFlowView(flow: Flow<ProfileRoute>(), apiService: apiService)
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
