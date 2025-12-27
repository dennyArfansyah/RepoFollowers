//
//  RemoteFollowerLoaderTests.swift
//  RepoFollowerTests
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import XCTest
import RepoFollower

final class RemoteFollowerLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = createSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        // Arrange
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = createSUT(url: url)
        
        // act
        sut.load { _ in }
        sut.load { _ in }
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = createSUT()
        
        expect(sut, toCompleteWithResults: .error(.connectivity) , when: {
            let clientError = NSError(domain: "Test Error", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = createSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResults: .error(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = createSUT()
        
        expect(sut, toCompleteWithResults: .error(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = createSUT()
        
        expect(sut, toCompleteWithResults: .success([]), when: {
            let emptyListJSON = Data("[]".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = createSUT()
        
        let item1 = makeItem(id: 190,
                                 login: "dennyarfansyah",
                                 avatarURL: "https://a-avatar-url.com",
                                 reposURL: "https://a-repo-url.com")
        let item2 = makeItem(id: 191,
                                 login: "arfansyahdenny",
                                 avatarURL: "https://another-avatar-url.com",
                                 reposURL: "https://another-repo-url.com")
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWithResults: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: - Helpers
    
    private func createSUT(url: URL = URL(string: "a-url.com")!) -> (sut: RemoteFollowerLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFollowerLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func makeItem(id: Int, login: String, avatarURL: String, reposURL: String) -> (model: FollowerItem, json: [String: Any]) {
        let item = FollowerItem(id: id, login: login, avatarURL: avatarURL, reposURL: reposURL)
        let json = [
            "id": id,
            "login": login,
            "avatar_url": avatarURL,
            "repos_url": reposURL
        ].compactMapValues { $0 }
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private func expect(_ sut: RemoteFollowerLoader,
                        toCompleteWithResults result: RemoteFollowerLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        var capturedResults = [RemoteFollowerLoader.Result]()
        sut.load { capturedResults.append($0)  }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.error(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
