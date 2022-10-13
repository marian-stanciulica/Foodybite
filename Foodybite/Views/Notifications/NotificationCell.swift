//
//  NotificationCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct NotificationCell: View {
    var body: some View {
        HStack {
            Image("profile_picture_test")
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(32)
            
            VStack(alignment: .leading) {
                Text("Branson Hawkins")
                    .padding(.vertical, 2)
                    .font(.headline)
                
                Text("Start following you")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text("29/05/2022")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell()
    }
}
