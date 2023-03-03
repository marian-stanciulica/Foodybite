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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Filter")
                    .font(.title)
                
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.horizontal)
            
            Text("Distance")
                .font(.title)
                .padding(.top)
            
            SelectRadiusView(radius: radius)
                .padding(.bottom, 56)
            
            Text("Ratings")
                .font(.title)
                .padding(.top)
            
            RatingView(stars: $starsNumber)
            
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
