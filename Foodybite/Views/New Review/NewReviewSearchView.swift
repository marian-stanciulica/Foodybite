//
//  NewReviewSearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import SwiftUI
import Domain

struct NewReviewSearchView: View {
    @Binding var searchText: String
    @Binding var autocompleteResults: [AutocompletePrediction]
    let onChange: () async -> Void
    let onPlaceSelected: (String) async -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SearchView(searchText: $searchText)
                .onChange(of: searchText) { newValue in
                    Task {
                        await onChange()
                    }
                }
            
            if !autocompleteResults.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(autocompleteResults, id: \.placeID) { result in
                        VStack {
                            RoundedRectangle(cornerRadius: 0.5)
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.2))
                                .padding(0)
                            
                            HStack {
                                Text(result.placePrediction)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        .onTapGesture {
                            autocompleteResults = []
                            searchText = ""
                            
                            Task {
                                await onPlaceSelected(result.placeID)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding()
    }
}

struct NewReviewSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NewReviewSearchView(searchText: .constant(""), autocompleteResults: .constant([]), onChange: {}, onPlaceSelected: { _ in })
    }
}