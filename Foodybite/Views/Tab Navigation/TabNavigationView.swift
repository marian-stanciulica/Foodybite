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
    @StateObject var viewModel: TabNavigationViewModel
    
    var body: some View {
        Group {
            switch tabRouter.currentPage {
            case .home:
                switch viewModel.state {
                case .isLoading:
                    ProgressView()
                case let .loaded(location):
                    HomeFlowView(page: $tabRouter.currentPage,
                                 flow: Flow<HomeRoute>(),
                                 apiService: apiService,
                                 placesService: placesService,
                                 currentLocation: location)
                case let .loadingError(message):
                    Text(message)
                }
            case .newReview:
                TabBarPageView(page: $tabRouter.currentPage) {
                    NewReviewView(currentPage: $tabRouter.currentPage, plusButtonActive: $plusButtonActive)
                }
            case .account:
                TabBarPageView(page: $tabRouter.currentPage) {
                    ProfileFlowView(flow: Flow<ProfileRoute>(), apiService: apiService)
                }
            }
        }
        .task {
            await viewModel.getCurrentLocation()
        }
    }
}
