//
//  SearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI
import FoodybitePlaces

struct SearchView: View {
    @Binding var searchText: String
    @Binding var isActive: Bool
    
    @State private var isSearchCriteriaPresented = false
    @FocusState private var isTextFieldFocused: Bool

    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                
                TextField(
                    "Find Restaurants",
                    text: $searchText,
                    onEditingChanged: { _ in
                        Task {
                            await viewModel.autocomplete(input: searchText)
                        }
                    }
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
            
            if isTextFieldFocused {
                List {
                    ForEach(viewModel.searchResults) { result in
                        Button(result.placeName) {
                            isTextFieldFocused = false
                        }
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchView(
                searchText: .constant(""),
                isActive: .constant(false),
                viewModel: SearchViewModel(
                    service: PreviewPlaceAutocompleteService())
            )
            
            Spacer()
        }
    }
    
    private class PreviewPlaceAutocompleteService: PlaceAutocompleteService {
        func autocomplete(input: String) async throws -> [AutocompletePrediction] {
            return [
                AutocompletePrediction(placeID: "place id 1", placeName: "place name 1"),
                AutocompletePrediction(placeID: "place id 2", placeName: "place name 2"),
                AutocompletePrediction(placeID: "place id 3", placeName: "place name 3"),
            ]
        }
    }
}
