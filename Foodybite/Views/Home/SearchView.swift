//
//  SearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI
import Domain
import FoodybitePlaces

struct SearchView: View {
    @Binding var searchText: String
    @Binding var isActive: Bool
    
    @State private var isSearchCriteriaPresented = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                
                TextField(
                    "Find Restaurants",
                    text: $searchText,
                    onEditingChanged: { _ in }
                )
                .foregroundColor(.gray)
                .focused($isTextFieldFocused)
                
                Spacer()
                
                if isTextFieldFocused {
                    Button {
                        searchText = ""
                        isTextFieldFocused = false
                    } label: {
                        Image("close")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                } else {
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
}
