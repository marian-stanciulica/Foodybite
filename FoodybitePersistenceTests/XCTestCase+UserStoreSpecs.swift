//
//  XCTestCase+UserStoreSpecs.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import FoodybitePersistence

extension UserStoreSpecs where Self: XCTestCase {
    
    func assertThatReadDeliversErrorOnCacheMiss(on sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFail(sut: sut, file: file, line: line)
    }
    
    func assertThatReadHasNoSideEffectsOnCacheMiss(on sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFailTwice(sut: sut, file: file, line: line)
    }
    
    
    // MARK: - Helpers
    
    private func expectReadToFail(sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
    private func expectReadToFailTwice(sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFail(sut: sut)
        await expectReadToFail(sut: sut)
    }
    
}
