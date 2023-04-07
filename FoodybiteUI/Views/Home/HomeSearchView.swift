//
//  HomeSearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct HomeSearchView<SearchCriteriaView: View>: View {
    @Binding var searchText: String
    @State var showSearchCriteria = false
    let searchCriteriaView: SearchCriteriaView

    public init(searchText: Binding<String>, searchCriteriaView: SearchCriteriaView) {
        self._searchText = searchText
        self.searchCriteriaView = searchCriteriaView
    }

    public var body: some View {
        ZStack(alignment: .trailing) {
            SearchView(searchText: $searchText)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                )

            if searchText.isEmpty {
                Button {
                    showSearchCriteria.toggle()
                } label: {
                    Image("filters_icon", bundle: .current)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray3)
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
        }
        .sheet(isPresented: $showSearchCriteria) {
            searchCriteriaView
        }
    }
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView(
            searchText: .constant(""),
            searchCriteriaView:
                SearchCriteriaView(
                    viewModel: SearchCriteriaViewModel(
                        userPreferences: UserPreferences(radius: 200, starsNumber: 3),
                        userPreferencesSaver: PreviewUserPreferencesSaver()
                    )
                )
        )
    }

    private class PreviewUserPreferencesSaver: UserPreferencesSaver {
        func save(_ userPreferences: UserPreferences) {}
    }
}
