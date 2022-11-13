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
    @AppStorage("userLoggedIn") var userLoggedIn = false
    
    var body: some Scene {
        let remoteResourceLoader = RemoteResourceLoader(client: URLSessionHTTPClient())
        let apiService = APIService(loader: remoteResourceLoader, sender: remoteResourceLoader)
        
        WindowGroup {
            if userLoggedIn {
                TabNavigationView()
                    .environmentObject(ViewRouter())
            } else {
                LoginView(viewModel: LoginViewModel(loginService: apiService))
            }
        }
    }
}
