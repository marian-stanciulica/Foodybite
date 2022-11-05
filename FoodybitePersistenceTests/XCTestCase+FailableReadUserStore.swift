//
//  XCTestCase+FailableReadUserStore.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import FoodybitePersistence

extension FailableReadUserStoreSpecs where Self: XCTestCase {
 
    func assertThatReadDeliversErrorOnInvalidData(on sut: UserStore, file: StaticString = #file, line: UInt = #line) async throws {
        try await writeInvalidData()
        
        await expectReadToFail(sut: sut, file: file, line: line)
    }
    
    private func writeInvalidData() async throws {
        let invalidData = "invalid data".data(using: .utf8)
        try invalidData?.write(to: resourceSpecificURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
    }
    
    private func resourceSpecificURL() -> URL {
        return testSpecificStoreURL()
            .appending(path: "User.resource")
    }
    
}
