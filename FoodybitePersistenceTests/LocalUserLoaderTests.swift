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
        client.setRead(returnedObject: user.local)
        
        await expectLoad(sut, toCompleteWith: .success(user.model))
    }
    
    func test_load_hasNoSideEffectsWhenCalledTwice() async {
        let (sut, client) = makeSUT()
        
        let user = anyUser()
        client.setRead(returnedObject: user.local)
        
        await expectLoad(sut, toCompleteWith: .success(user.model))
        await expectLoad(sut, toCompleteWith: .success(user.model))
    }
    
    func test_save_doesntWriteOnDeletionError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()
        client.setDeletion(error: expectedError)
        
        try? await sut.save(user: anyUser().model)
        
        XCTAssertEqual(client.messages, [.delete])
    }
    
    func test_save_returnsErrorOnDeletionError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()
        client.setDeletion(error: expectedError)
        
        await expectSave(sut, toCompleteWith: expectedError)
    }
    
    func test_save_writesAfterDeletionSucceeded() async {
        let (sut, client) = makeSUT()
        client.setDeletion(error: nil)
        
        try? await sut.save(user: anyUser().model)
        
        XCTAssertEqual(client.messages, [.delete, .write])
    }
    
    func test_save_sendsParameterToWrite() async {
        let (sut, client) = makeSUT()
        let user = anyUser()
        client.setDeletion(error: nil)
        
        try? await sut.save(user: user.model)
        
        XCTAssertEqual(client.writeParameter, user.local)
    }
    
    func test_save_returnsErrorOnWriteError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()

        client.setDeletion(error: nil)
        client.setWrite(error: expectedError)
        
        await expectSave(sut, toCompleteWith: expectedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalUserLoader, store: UserStoreSpy) {
        let store = UserStoreSpy()
        let sut = LocalUserLoader(store: store)
        return (sut, store)
    }
    
    private func expectLoad(_ sut: LocalUserLoader, toCompleteWith expectedResult: Result<User, Error>) async {
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, try expectedResult.get())
        } catch {
            XCTAssertEqual(error as NSError, expectedResult.error as NSError?)
        }
    }
    
    private func expectSave(_ sut: LocalUserLoader, toCompleteWith expectedError: Error?) async {
        do {
            try await sut.save(user: anyUser().model)
        } catch {
            XCTAssertEqual(error as NSError, expectedError as NSError?)
        }
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private func anyUser() -> (model: User, local: LocalUser) {
        let local = LocalUser(id: UUID(),
                              name: "any name",
                              email: "any@email.com",
                              profileImage: nil)
        return (local.model, local)
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
