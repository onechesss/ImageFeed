//
//  UserResult.swift
//  ImageFeed
//
//  Created by oneche$$$ on 19.05.2025.
//

import Foundation

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
