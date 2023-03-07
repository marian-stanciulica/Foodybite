//
//  LocalUserLoaderTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 29.10.2022.
//

import XCTest
import FoodybitePersistence
import Domain

final class LocalUserLoaderTests: XCTestCase {

    func test_init_doesNotReceiveMessagesUponCreation() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.messages, [])
    }
    
    func test_load_callClientRead() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.load()
        
        XCTAssertEqual(client.messages, [.read])
    }
    
    func test_load_returnsErrorOnClientError() async {
        let (sut, client) = makeSUT()
        
        let expectedError = anyNSError()
        client.setRead(error: expectedError)
        
        await expectLoad(sut, toCompleteWith: .failure(expectedError))
    }
    
    func test_load_returnsObjectSuccessfullyOnClientSuccess() async {
        let (sut, client) = makeSUT()
        
        let user = anyUser()
        client.setRead(returnedObject: user)
        
        await expectLoad(sut, toCompleteWith: .success(user))
    }
    
    func test_load_hasNoSideEffectsWhenCalledTwice() async {
        let (sut, client) = makeSUT()
        
        let user = anyUser()
        client.setRead(returnedObject: user)
        
        await expectLoad(sut, toCompleteWith: .success(user))
        await expectLoad(sut, toCompleteWith: .success(user))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalUserLoader<User, UserStoreSpy>, store: UserStoreSpy) {
        let store = UserStoreSpy()
        let sut = LocalUserLoader<User, UserStoreSpy>(store: store)
        return (sut, store)
    }
    
    private func expectLoad(_ sut: LocalUserLoader<User, UserStoreSpy>, toCompleteWith expectedResult: Result<User, Error>) async {
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, try expectedResult.get())
        } catch {
            XCTAssertEqual(error as NSError, expectedResult.error as NSError?)
        }
    }
    
    private func expectSave(_ sut: LocalUserLoader<User, UserStoreSpy>, toCompleteWith expectedError: Error?) async {
        do {
            try await sut.save(user: anyUser())
        } catch {
            XCTAssertEqual(error as NSError, expectedError as NSError?)
        }
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private func anyUser() -> User {
        return User(id: UUID(),
                      name: "any name",
                      email: "any@email.com",
                      profileImage: nil)
    }
}

private extension Result {
    var error: Error? {
        switch self {
        case let .failure(error):
            return error
        default:
            return nil
        }
    }
}
