//
//  Profile.swift
//  ImageFeed
//
//  Created by oneche$$$ on 18.05.2025.
//

struct Profile {
    let username: String
    var name: String
    var loginName: String { return "@\(username)" }
    let bio: String
}
