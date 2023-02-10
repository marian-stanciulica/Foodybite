//
//  TabNavigationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces
import Domain

struct TabNavigationView: View {
    @StateObject var tabRouter: TabRouter
    @State var plusButtonActive = false
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    @StateObject var viewModel: TabNavigationViewModel
    let user: User
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .isLoading:
                ProgressView()
                
            case let .loadingError(message):
                Text(message)
                
            case let .loaded(location):
                switch tabRouter.currentPage {
                case .home:
                HomeFlowView(page: $tabRouter.currentPage,
                             flow: Flow<HomeRoute>(),
                             apiService: apiService,
                             placesService: placesService,
                             currentLocation: location)
                case .newReview:
                    TabBarPageView(page: $tabRouter.currentPage) {
                        NewReviewView(
                            currentPage: $tabRouter.currentPage,
                            plusButtonActive: $plusButtonActive,
                            viewModel: NewReviewViewModel(
                                autocompletePlacesService: placesService,
                                getPlaceDetailsService: placesService,
                                fetchPlacePhotoService: placesService,
                                addReviewService: apiService,
                                location: location
                            )
                        )
                    }
                case .account:
                    ProfileFlowView(page: $tabRouter.currentPage, flow: Flow<ProfileRoute>(), apiService: apiService, placesService: placesService, user: user, currentLocation: location)
                }
            }
        }
        .task {
            await viewModel.getCurrentLocation()
        }
    }
}
