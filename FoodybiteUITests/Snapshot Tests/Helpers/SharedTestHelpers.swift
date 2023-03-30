//
//  SharedTestHelpers.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import XCTest
import SnapshotTesting

func assertLightSnapshot(
    matching value: UIViewController,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .light)
    
    assertSnapshot(matching: value,
                   as: .image(on: .iPhone13, traits: trait),
                   named: "light",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}

func assertDarkSnapshot(
    matching value: UIViewController,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .dark)
    
    assertSnapshot(matching: value,
                   as: .image(on: .iPhone13, traits: trait),
                   named: "dark",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}
