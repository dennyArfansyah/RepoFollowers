//
//  FollowerItem.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 23/12/2025.
//

import Foundation

public struct FollowerItem: Equatable {
    let id: Int
    let login: String
    let avatarURL: URL
    let reposURL: URL
}
