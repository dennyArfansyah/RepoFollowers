//
//  RemoteFollowerLoaderTests.swift
//  RepoFollowerTests
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import XCTest

class RemoteFollowerLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFollowerLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFollowerLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        HTTPClient.shared = client
         let sut = RemoteFollowerLoader()
        
        // act
        sut.load()
        
        // Assert
        XCTAssertNotNil(client.requestedURL)
    }
}
