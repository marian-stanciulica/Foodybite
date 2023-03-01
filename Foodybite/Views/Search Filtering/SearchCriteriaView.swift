//
//  SearchCriteriaView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct SearchCriteriaView: View {
    @State var radius: CGFloat
    @Binding var starsNumber: Int
    
    var body: some View {
        VStack {
            Text("Distance")
                .font(.title)
                .padding(.top)
            
            SelectRadiusView(radius: radius)
                .padding(.bottom)
            
            Text("Ratings")
                .font(.title)
                .padding(.top)
            
            RatingView(stars: $starsNumber)
                .padding(.bottom)
            
            Spacer()
            
            HStack {
                MarineButton(title: "Reset", isLoading: false) {
                    
                }
                
                MarineButton(title: "Apply", isLoading: false) {
                    
                }
            }
        }
        .padding()
    }
}

struct SearchCriteriaView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCriteriaView(radius: 20, starsNumber: .constant(4))
    }
}
