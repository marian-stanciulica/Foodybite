//
//  TabRouter.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI

class TabRouter: ObservableObject {
    @Published var currentPage: Page = .home
}

enum Page {
    case home
    case favorites
    case newReview
    case notifications
    case account
}
