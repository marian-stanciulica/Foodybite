//
//  HomeSearchView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import SwiftUI

struct HomeSearchView: View {
    @Binding var searchText: String
    @State var showSearchCriteria = false
    
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
            SearchCriteriaView(radius: 100, starsNumber: .constant(2))
        }
    }
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView(searchText: .constant(""))
    }
}
