//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

@main
struct FoodybiteApp: App {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some Scene {
        WindowGroup {
            TabNavigationView()
                .environmentObject(ViewRouter())
        }
    }
}
