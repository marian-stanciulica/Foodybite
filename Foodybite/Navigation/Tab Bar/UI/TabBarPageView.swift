//
//  TabBarPageView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 05.02.2023.
//

import SwiftUI

struct TabBarPageView<Content: View>: View {
    @Binding var page: Page
    @State var plusButtonActive = false
    let content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                content()
                
                Spacer()
                
                TabBarView(plusButtonActive: $plusButtonActive,
                           currentPage: $page,
                           tabBarWidth: geometry.size.width,
                           tabBarHeight: geometry.size.height / 6,
                           iconWidth: geometry.size.width / 5,
                           iconHeight: geometry.size.height / 32)
                .background(.gray.opacity(0.1))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
