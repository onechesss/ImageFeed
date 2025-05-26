//
//  Profile.swift
//  ImageFeed
//
//  Created by oneche$$$ on 18.05.2025.
//

struct Profile {
    let username: String
    let name: String
    var loginName: String { "@\(username)" }
    let bio: String
}
