//
//  PeopleListView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct PeopleListView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0...50, id: \.self) { _ in
                    PeopleListCell(accountType: .constant(.following))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleListView()
    }
}
