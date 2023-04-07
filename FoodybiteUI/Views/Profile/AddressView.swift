//
//  AddressView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import SwiftUI

struct AddressView: View {
    let restaurantName: String
    let address: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(restaurantName)
                .font(.title2.weight(.bold))
                .padding(.bottom, 2)

            Text(address)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(restaurantName: "Name", address: "address")
    }
}
