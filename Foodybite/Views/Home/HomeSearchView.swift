//
//  HomeSearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import SwiftUI

struct HomeSearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading)
            
            TextField("Search Restaurant", text: $searchText)
                .padding(.vertical, 12)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding()
    }
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView(searchText: .constant(""))
    }
}
