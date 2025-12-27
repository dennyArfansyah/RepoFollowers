//
//  HTTPClient.swift
//  RepoFollower
//
//  Created by Denny Arfansyah on 28/12/2025.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case error(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
