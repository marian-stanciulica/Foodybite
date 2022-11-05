//
//  XCTestCase+FailableDeleteUserStoreSpecs.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import FoodybitePersistence

extension FailableDeleteUserStoreSpecs where Self: XCTestCase {
    
    func assertThatDeleteHasNoSideEffectsOnDeleteError(on sut: UserStore, file: StaticString = #file, line: UInt = #line) async throws {
        try await sut.delete()
        
        do {
            let result = try await sut.read()
            XCTFail("Expected read to fail, got \(result) instead", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
}
