//
//  SearchCriteriaView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct SearchCriteriaView: View {
    var body: some View {
        VStack {
            Text("Distance")
                .font(.title)
                .padding(.top)
            
            SelectRadiusView(radius: 20)
                .padding(.bottom)
            
            Text("Ratings")
                .font(.title)
                .padding(.top)
            
            RatingView(stars: .constant(3))
                .padding(.bottom)
            
            Spacer()
            
            HStack {
                MarineButton(title: "Reset") {
                    
                }
                
                MarineButton(title: "Apply") {
                    
                }
            }
        }
        .padding()
    }
}

struct SearchCriteriaView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCriteriaView()
    }
}
