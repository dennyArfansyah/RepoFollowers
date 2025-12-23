//
//  FollowerLoader.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 23/12/2025.
//

protocol FollowerLoader {
    typealias Result = Swift.Result<[FollowerItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
