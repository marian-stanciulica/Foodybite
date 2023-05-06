//
//  FetchLocationView.swift
//  FoodybiteUI
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct FetchLocationView<TabBar: View>: View {
    @StateObject var viewModel: FetchLocationViewModel
    let username: String
    let makeTabNavigationView: (Location) -> TabBar

    public init(viewModel: FetchLocationViewModel, username: String, makeTabNavigationView: @escaping (Location) -> TabBar) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.username = username
        self.makeTabNavigationView = makeTabNavigationView
    }

    public var body: some View {
        if viewModel.locationServicesEnabled {
            feedbackCurrentLocationFetch()
                .task {
                    await viewModel.getCurrentLocation()
                }
        } else {
            TurnOnLocationView(name: username, locationProvider: viewModel.locationProvider)
        }
    }

    @ViewBuilder private func feedbackCurrentLocationFetch() -> some View {
        switch viewModel.state {
        case .isLoading:
            ProgressView()

        case let .failure(error):
            Text(error.rawValue)

        case let .success(location):
            makeTabNavigationView(location)
        }
    }
}
