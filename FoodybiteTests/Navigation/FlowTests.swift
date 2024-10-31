//
//  FlowTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import Testing
@testable import Foodybite

struct FlowTests {

    @Test func authRoute_containsAllCases() {
        #expect(AuthRoute.allCases == [.signUp])
    }

    @Test func append_appendsValueToNavigationPath() {
        let sut = Flow<AuthRoute>()

        #expect(sut.path.count == 0)

        sut.append(.signUp)
        #expect(sut.path.count == 1)
    }

    @Test func navigateBack_removesLastValueFromNavigationPath() {
        let sut = Flow<ProfileRoute>()

        sut.append(.settings)
        #expect(sut.path == [.settings])

        sut.append(.changePassword)
        #expect(sut.path == [.settings, .changePassword])

        sut.navigateBack()
        #expect(sut.path == [.settings])

        sut.navigateBack()
        #expect(sut.path.isEmpty)
    }
}
