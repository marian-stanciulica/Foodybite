//
//  UserDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class UserDAO {
    private let store: LocalStore
    
    init(store: LocalStore) {
        self.store = store
    }
    
    func getUser(id: UUID) async throws -> User {
        throw NSError(domain: "", code: 1)
    }
}

final class UserDAOTests: XCTestCase {
    
    func test_getUser_throwsErrorWhenUserNotFound() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let user = try await sut.getUser(id: UUID())
            XCTFail("Expected to fail, received user \(user) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: UserDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = UserDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
}
