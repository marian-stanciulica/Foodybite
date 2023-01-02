//
//  SearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    @State private var isSearchCriteriaPresented = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)
            
            TextField("Find Restaurants", text: $searchText)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button {
                isSearchCriteriaPresented = true
            } label: {
                Image("filters_icon")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .fullScreenCover(isPresented: $isSearchCriteriaPresented) {
                SearchCriteriaView()
            }
         }
        .padding()
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
        VStack {
            SearchView(searchText: .constant(""))
            Spacer()
        }
    }
}
