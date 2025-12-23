//
//  RemoteFollowerLoaderTests.swift
//  RepoFollowerTests
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import XCTest

class RemoteFollowerLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}


final class RemoteFollowerLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFollowerLoader()
        
        XCTAssertNil(client.requestedURL)
        
    }
}
