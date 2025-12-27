//
//  RemoteFollowerLoader.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case error(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

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
                if response.statusCode == 200,
                   let followers = try? JSONDecoder().decode([Item].self, from: data) {
                    completion(.success(followers.map { $0.item }))
                } else {
                    completion(.error(.invalidData))
                }
            case .error:
                completion(.error(.connectivity))
            }
        }
    }
}

private struct Item: Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    let repos_url: String
    
    var item: FollowerItem {
        return FollowerItem(id: id, login: login, avatarURL: avatar_url, reposURL: repos_url)
    }
}
                    
