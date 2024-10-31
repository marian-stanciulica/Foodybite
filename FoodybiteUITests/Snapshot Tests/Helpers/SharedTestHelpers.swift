//
//  SharedTestHelpers.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import SwiftUI
import SnapshotTesting

func assertLightAndDarkSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage> = .image(on: .iPhone13),
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    assertLightSnapshot(matching: value, as: snapshotting, record: recording, file: file, testName: testName, line: line)
    assertDarkSnapshot(matching: value, as: snapshotting, record: recording, file: file, testName: testName, line: line)
}

func assertLightSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .light)
    let view = UIHostingController(rootView: value)

    assertSnapshot(matching: view,
                   as: .image(on: .iPhone13, perceptualPrecision: 0.99, traits: trait),
                   named: "light",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}

func assertDarkSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .dark)
    let view = UIHostingController(rootView: value)

    assertSnapshot(matching: view,
                   as: .image(on: .iPhone13, perceptualPrecision: 0.99, traits: trait),
                   named: "dark",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}
