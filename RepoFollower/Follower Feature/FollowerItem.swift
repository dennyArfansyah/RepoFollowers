//
//  FollowerItem.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 23/12/2025.
//

public struct FollowerItem: Equatable {
    public let id: Int
    public let login: String
    public let avatarURL: String
    public let reposURL: String
    
    public init(id: Int, login: String, avatarURL: String, reposURL: String) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.reposURL = reposURL
    }
}

extension FollowerItem: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
    }
}
