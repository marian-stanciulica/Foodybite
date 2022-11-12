//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

@main
struct FoodybiteApp: App {
    @AppStorage("userLoggedIn") var userLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if userLoggedIn {
                TabNavigationView()
                    .environmentObject(ViewRouter())
            } else {
                
            }
        }
    }
}
