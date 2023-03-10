//
//  FoodybiteCacheIntegrationTests.swift
//  FoodybiteCacheIntegrationTests
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class FoodybiteUserCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    // MARK: - LocalUserLoader Tests
    
    func test_loadUser_deliversNilOnEmptyCache() async {
        let userLoader = makeUserLoader()
        
        let user: User? = try? await userLoader.read()
        
        XCTAssertEqual(user, nil)
    }
    
    func test_loadUser_deliversUserSavedOnASeparateInstance() async throws {
        let userLoaderToPerformSave = makeUserLoader()
        let userLoaderToPerformLoad = makeUserLoader()
        let user = makeUser()
        
        try await userLoaderToPerformSave.write(user)
        
        let receivedUser: User = try await userLoaderToPerformLoad.read()
        XCTAssertEqual(receivedUser, user)
    }
    
    func test_saveUser_overridesUserSavedOnASeparateInstance() async throws {
        let userLoaderToPerformFirstSave = makeUserLoader()
        let userLoaderToPerformSecondSave = makeUserLoader()
        let userLoaderToPerformLoad = makeUserLoader()
        let firstUser = makeUser()
        let secondUser = makeUser()
        
        try await userLoaderToPerformFirstSave.write(firstUser)
        try await userLoaderToPerformSecondSave.write(secondUser)
        
        let receivedUser: User = try await userLoaderToPerformLoad.read()
        XCTAssertEqual(receivedUser, secondUser)
    }
    
    // MARK: - Helpers
    
    private func makeUserLoader() -> LocalStore {
        let storeURL = testSpecificStoreURL()
        let sut = try! CoreDataLocalStore(storeURL: storeURL)
        return sut
    }
    
    private func makeUser() -> User {
        User(id: UUID(), name: "User #1", email: "testing@testing.com", profileImage: nil)
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
