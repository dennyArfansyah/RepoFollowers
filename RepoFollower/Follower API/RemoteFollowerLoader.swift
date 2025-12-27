//
//  RemoteFollowerLoader.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import Foundation

public final class RemoteFollowerLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FollowerItem])
        case error(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            
            switch result {
            case let .success(data, response):
                completion(FollowerItemMapper.map(data, from: response))
            case .error:
                completion(.error(.connectivity))
            }
        }
    }
}
