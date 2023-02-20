//
//  LoadEpisodesFromRemoteUseCaseTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
import XCTest
@testable import RickAndMorty

class LoadEpisodesFromRemoteUseCaseTest: XCTestCase {
    
    let parameters = ["page": 1]
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT(parameters: parameters)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url, parameters: parameters)

        sut.load(parameters: parameters) { _ in }
        sut.load(parameters: parameters) { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT(parameters: parameters)

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT(parameters: parameters)

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeDataJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT(parameters: parameters)

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, parameters: [String: Any]?, file: StaticString = #filePath, line: UInt = #line) -> (sut: EpisodeService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = EpisodeServiceAPI(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func makeDataJSON(_ data: [[String: Any]]) -> Data {
        let json = ["results": data]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

extension LoadEpisodesFromRemoteUseCaseTest {
    func expect(_ sut: EpisodeService, toCompleteWith expectedResult: Result<[EpisodeResult], EpisodeServiceAPI.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load(parameters: parameters) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)) :
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as EpisodeServiceAPI.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
        }
        
        exp.fulfill()

        action()

        waitForExpectations(timeout: 0.1)
    }
}
