//
//  RemoteFollowerLoaderTests.swift
//  RepoFollowerTests
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import XCTest

class RemoteFollowerLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
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
        let client = HTTPClientSpy()
        _ = RemoteFollowerLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
         let sut = RemoteFollowerLoader(client: client)
        
        // act
        sut.load()
        
        // Assert
        XCTAssertNotNil(client.requestedURL)
    }
}
