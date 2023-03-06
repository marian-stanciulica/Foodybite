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
        
        let user = try? await userLoader.load()
        
        XCTAssertEqual(user, nil)
    }
    
    func test_loadUser_deliversUserSavedOnASeparateInstance() async throws {
        let userLoaderToPerformSave = makeUserLoader()
        let userLoaderToPerformLoad = makeUserLoader()
        let user = makeUser()
        
        try await userLoaderToPerformSave.save(user: user)
        
        let receivedUser = try await userLoaderToPerformLoad.load()
        XCTAssertEqual(receivedUser, user)
    }
    
    // MARK: - Helpers
    
    private func makeUserLoader() -> LocalUserLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataUserStore(storeURL: storeURL)
        let sut = LocalUserLoader(store: store)
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
