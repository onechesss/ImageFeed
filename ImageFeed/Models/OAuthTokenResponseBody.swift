//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by oneche$$$ on 11.05.2025.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
