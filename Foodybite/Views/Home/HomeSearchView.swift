//
//  HomeSearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import SwiftUI
import Domain

struct HomeSearchView: View {
    @Binding var searchText: String
    @State var showSearchCriteria = false
    let searchCriteriaView: AnyView
    
    var body: some View {
        ZStack(alignment: .trailing) {
            SearchView(searchText: $searchText)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                )
            
            Button {
                showSearchCriteria.toggle()
            } label: {
                Image("filters_icon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(uiColor: .systemGray3))
                    .frame(width: 20, height: 20)
                    .padding()
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
            searchCriteriaView: AnyView(
                SearchCriteriaView(
                    viewModel: SearchCriteriaViewModel(
                        userPreferences: UserPreferences(radius: 200, starsNumber: 3),
                        userPreferencesSaver: PreviewUserPreferencesSaver()
                    )
                )
            )
        )
    }
    
    private class PreviewUserPreferencesSaver: UserPreferencesSaver {
        func save(_ userPreferences: UserPreferences) {}
    }
}
