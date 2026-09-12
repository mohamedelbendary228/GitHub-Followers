//
//  Follower.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 25/08/2026.
//

import Foundation

nonisolated struct Follower: Codable, Hashable, Sendable {
    var login: String
    var avatarUrl: String
}
