//
//  FavoritesView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    
                    Text("My Favorite")
                        .font(.title)
                    
                    Spacer()
                }
                
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(0...50, id: \.self) { _ in
                        RestaurantCell()
                            .background(.white)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .background(.gray.opacity(0.1))
    }
}
