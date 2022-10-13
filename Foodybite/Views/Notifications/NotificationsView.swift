//
//  NotificationsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.title)
            
            ScrollView {
                LazyVStack {
                    ForEach(0...50, id: \.self) { _ in
                        NotificationCell()
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
