//
//  TabRouter.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Foundation

class TabRouter: ObservableObject {
    enum Page {
        case home
        case newReview
        case account
    }
    
    @Published var currentPage: Page = .home
}
