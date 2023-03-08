//
//  TabRouter.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Foundation

class TabRouter: ObservableObject {
    @Published var currentPage: Page = .home
}

enum Page {
    case home
    case newReview
    case account
}
