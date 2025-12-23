//
//  FollowerLoader.swift
//  FeedEssentialClone
//
//  Created by Denny Arfansyah on 23/12/2025.
//

enum LoadFollowerResult {
    case success([FollowerItem])
    case error(Error)
}

protocol FollowerLoader {
    func load(completion: @escaping (LoadFollowerResult) -> Void)
}
