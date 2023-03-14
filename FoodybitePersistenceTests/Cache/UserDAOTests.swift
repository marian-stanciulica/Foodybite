//
//  UserDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class UserDAOTests: XCTestCase {
    
    func test_getUser_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let user = try await sut.getUser(id: UUID())
            XCTFail("Expected to fail, received user \(user) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getUser_throwsErrorWhenUserNotFound() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readAllResult = .success([makeUser(), makeUser(), makeUser()])
        
        do {
            let user = try await sut.getUser(id: UUID())
            XCTFail("Expected to fail, received user \(user) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getUser_returnsFoundUserWhenFoundInStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedUser = makeUser()
        storeSpy.readAllResult = .success([makeUser(), makeUser()] + [expectedUser])
        
        let receivedUser = try await sut.getUser(id: expectedUser.id)
        XCTAssertEqual(expectedUser, receivedUser)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: UserDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = UserDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
    private func makeUser() -> User {
        User(id: UUID(), name: "User", email: "user@user.com", profileImage: nil)
    }
    
}
