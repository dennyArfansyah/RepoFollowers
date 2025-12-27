//
//  FollowerItemMapper.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 28/12/2025.
//

import Foundation

final class FollowerItemMapper {
    private struct Item: Decodable {
        let id: Int
        let login: String
        let avatar_url: String
        let repos_url: String
        
        var item: FollowerItem {
            return FollowerItem(id: id,
                                login: login,
                                avatarURL: avatar_url,
                                reposURL: repos_url)
        }
    }
    
    private static var OK_200: Int { 200 }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FollowerItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFollowerLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode([Item].self, from: data)
        return root.map { $0.item }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFollowerLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode([Item].self, from: data) else {
            return RemoteFollowerLoader.Result.error(.invalidData)
        }
            
        let items = root.map { $0.item }
        return .success(items)
    }
}
