//
//  TurnOnLocationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import Domain

public struct TurnOnLocationView: View {
    private let name: String
    private let locationProvider: LocationProviding

    public init(name: String, locationProvider: LocationProviding) {
        self.name = name
        self.locationProvider = locationProvider
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            Text("Hi \(name), Welcome to ")
                .foregroundColor(.white)
                .font(.system(size: 50, weight: .bold)) +
            Text("Foodybite")
                .foregroundColor(.yellow)
                .font(.system(size: 50, weight: .bold))

            Spacer()

            Text("Please turn on your GPS to find out better restaurant suggestions near you.")
                .foregroundColor(.white)
                .font(.title2)

            Spacer()

            MarineButton(title: "Turn On GPS", isLoading: false) {
                locationProvider.requestWhenInUseAuthorization()
            }
        }
        .padding(.horizontal)
        .background(
            BackgroundImage(imageName: "turn_on_location_background")
        )
    }
}

struct TurnOnLocationView_Previews: PreviewProvider {
    static var previews: some View {
        TurnOnLocationView(name: "Marian", locationProvider: PreviewLocationProviding())
    }

    private class PreviewLocationProviding: LocationProviding {
        var locationServicesEnabled: Bool = true

        func requestLocation() async throws -> Location {
            Location(latitude: 0, longitude: 0)
        }

        func requestWhenInUseAuthorization() {}
    }
}
