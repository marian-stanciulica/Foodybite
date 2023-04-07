//
//  InitialsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import SwiftUI

struct InitialsView: View {
    let initials: String

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Text(initials)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.system(size: geometry.size.width * 0.8))
                    .background(
                        Circle()
                            .foregroundColor(.marineBlue)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    )
            }
        }
    }
}

struct InitialsView_Previews: PreviewProvider {
    static var previews: some View {
        InitialsView(initials: "M")
            .frame(width: 200, height: 200)
    }
}
