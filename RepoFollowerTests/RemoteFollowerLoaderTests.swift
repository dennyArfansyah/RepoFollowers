//
//  RemoteFollowerLoaderTests.swift
//  RepoFollowerTests
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import XCTest

class RemoteFollowerLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFollowerLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFollowerLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        // Arrange
        let url = URL(string: "http://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFollowerLoader(url: url, client: client)
        
        // act
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURL, client.requestedURL)
    }
}
