//
//  LocationCheckerView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import SwiftUI

struct LocationCheckView<NavigationView: View>: View {
    @StateObject var locationProvider = LocationProvider()
    let makeNavigationView: (LocationProvider) -> NavigationView
    
    var body: some View {
        if locationProvider.locationServicesEnabled {
            makeNavigationView(locationProvider)
        } else {
            TurnOnLocationView()
        }
    }
    
}
