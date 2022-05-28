//
//  TurnOnLocationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

struct TurnOnLocationView: View {
    @State var name = "John"

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()

                Button("Skip") {

                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1)
                )
                .background(.white.opacity(0.25))
            }
            .padding()

            Spacer()
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

            RoundedButton(title: "Turn On GPS") {

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
        TurnOnLocationView()
    }
}
