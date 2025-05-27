//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by oneche$$$ on 27.05.2025.
//

struct PhotoResults: Codable {
    let photos: [PhotoResult]
}

struct PhotoResult: Codable {
    let photoResult: [PhotoResult]
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: PhotoResultUrls
    
    private enum CodingKeys: String, CodingKey {
        case photoResult
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct PhotoResultUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
