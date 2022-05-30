//
//  SearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                 Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                 TextField("Find Restaurants", text: $searchText)
                    .foregroundColor(.gray)
                Spacer()
                Image("filters_icon")
                    .resizable()
                    .frame(width: 24, height: 24)
             }
            .padding()
        }
        .foregroundColor(.white)
        .overlay(
             RoundedRectangle(cornerRadius: 16)
                 .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""))
    }
}
