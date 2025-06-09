//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by oneche$$$ on 11.05.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() { }
    
    var token: String? {
        get {
            if KeychainWrapper.standard.string(forKey: "token") != "" && KeychainWrapper.standard.string(forKey: "token") != nil
            { return KeychainWrapper.standard.string(forKey: "token") }
            else { return nil }
        }
        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: "token")
        }
    }
}



