//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by oneche$$$ on 01.06.2025.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanTokenStorage()
        cleanProfileImage()
        cleanPhotosInImagesList()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanTokenStorage() {
        if KeychainWrapper.standard.removeObject(forKey: "token") {
            return
        } else {
            print("ошибка в ProfileLogoutService.swift: не получилось удалить token из storage (строка 37)")
            return
        }
    }
    
    private func cleanProfileImage() {
        ProfileImageService.shared.cleanAvatarURL()
    }
    
    private func cleanPhotosInImagesList() {
        ImagesListService.shared.cleanPhotos()
        NotificationCenter.default.post(name: NSNotification.Name("cleanPhotosInImagesList"), object: self)
        ImagesListViewController().cleanPhotosInImagesListViewController()
    }
}
