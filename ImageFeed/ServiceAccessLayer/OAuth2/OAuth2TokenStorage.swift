//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by oneche$$$ on 11.05.2025.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get { return UserDefaults.standard.string(forKey: "token") }
        set { return UserDefaults.standard.set(newValue, forKey: "token") }
    }
}
