//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by oneche$$$ on 08.06.2025.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var viewDidCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func viewDidLoad() {
        viewDidCalled = true
    }
}
