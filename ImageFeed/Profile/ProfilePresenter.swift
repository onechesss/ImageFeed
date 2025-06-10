//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by oneche$$$ on 07.06.2025.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        ProfileService.shared.fetchProfile(OAuth2TokenStorage.shared.token ?? "") { [weak self] profile in
            guard let self else { return }
            view?.setProfileInfo(profile: profile)
        }
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
}
