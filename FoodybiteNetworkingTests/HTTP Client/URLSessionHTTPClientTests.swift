//
//  URLSessionHTTPClientTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_send_performURLRequest() async throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(urlSession: session)
        
        _ = try? await sut.send(urlRequest)
        
        XCTAssertEqual(session.requests, [urlRequest])
    }
    
    func test_send_throwsErrorOnRequestError() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let expectedError = anyError()
        let session = URLSessionSpy(result: .failure(expectedError))
        let sut = URLSessionHTTPClient(urlSession: session)
        
        do {
            _ = try await sut.send(urlRequest)
            XCTFail("SUT should throw error on request error")
        } catch {
            XCTAssertEqual(expectedError, error as NSError)
        }
    }
    
    func test_send_throwErrorOnInvalidCases() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let session = URLSessionSpy(result: .success((anyData(), anyUrlResponse())))
        let sut = URLSessionHTTPClient(urlSession: session)
        
        do {
            _ = try await sut.send(urlRequest)
            XCTFail("SUT should throw error if response is URLResponse")
        } catch {}
    }
    
    func test_send_succeedsOnHTTPUrlResponseWithData() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let anyData = anyData()
        let anyHttpUrlResponse = anyHttpUrlResponse()
        let session = URLSessionSpy(result: .success((anyData, anyHttpUrlResponse)))
        let sut = URLSessionHTTPClient(urlSession: session)
        
        do {
            let (receivedData, receivedResponse) = try await sut.send(urlRequest)
            XCTAssertEqual(receivedData, anyData)
            XCTAssertEqual(receivedResponse.url, anyHttpUrlResponse.url)
            XCTAssertEqual(receivedResponse.statusCode, anyHttpUrlResponse.statusCode)
        } catch {
            XCTFail("Should receive data and response, got \(error) instead")
        }
    }

}
