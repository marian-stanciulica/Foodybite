//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking

@main
struct FoodybiteApp: App {
    @State var userLoggedIn = false
//    @AppStorage("userLoggedIn") var userLoggedIn = false
    
    private let apiService = APIService(loader: RemoteResourceLoader(client: URLSessionHTTPClient()),
                                        sender: RemoteResourceLoader(client: URLSessionHTTPClient()),
                                        tokenStore: KeychainTokenStore())
    
    var body: some Scene {
        WindowGroup {
            if userLoggedIn {
                TabNavigationView()
                    .environmentObject(ViewRouter())
            } else {
                AuthFlowView(userLoggedIn: $userLoggedIn, apiService: apiService, flow: AuthFlow())
            }
        }
    }
}
