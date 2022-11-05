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
    
    func assertThatReadDeliversResourceOnCacheHit(on sut: UserStore, file: StaticString = #file, line: UInt = #line) async throws {
        let expectedUser = anyUser()
        try await sut.write(expectedUser)
        
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, file: file, line: line)
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
    
    private func expectReadToSucceed(sut: UserStore, withExpected expectedUser: LocalUser, file: StaticString = #file, line: UInt = #line) async {
        do {
            let receivedResource = try await sut.read()
            XCTAssertEqual(receivedResource, expectedUser, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }
    
    private func anyUser() -> LocalUser {
        return LocalUser(id: UUID(), name: "any name", email: "any@email.com", profileImage: URL(string: "http://any.com")!)
    }
    
}
