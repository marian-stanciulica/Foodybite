//
//  XCTestCase+FailableWriteUserStoreSpecs.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import FoodybitePersistence

extension FailableWriteUserStoreSpecs where Self: XCTestCase {

    func assertThatWriteDeliversErrorOnWriteError(on sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        do {
            try await sut.write(anyUser())
            XCTFail("Expected write to fail", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
}
