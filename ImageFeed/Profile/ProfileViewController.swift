//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by oneche$$$ on 03.04.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        ProfileService.shared.fetchProfile(OAuth2TokenStorage.shared.token ?? "") { profile in
            DispatchQueue.main.async {
                self.nameLabel.text = profile.name
                self.descriptionLabel.text = profile.bio
                self.loginNameLabel.text = profile.loginName
            }
        }
        
        setUpProfilePicture(imageView: imageView)
        setUpNameLabel(nameLabel: nameLabel, imageView: imageView)
        setUpLoginNameLabel(loginNameLabel: loginNameLabel, nameLabel: nameLabel)
        setUpDescriptionLabel(descriptionLabel: descriptionLabel, loginNameLabel: loginNameLabel)
        setUpLogoutButton(logoutButton: logoutButton)
        setupBackgroundColor(vc: self)
    }

    private func setUpProfilePicture(imageView: UIImageView)
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.image = UIImage(named: "avatar")
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func setUpNameLabel(nameLabel: UILabel, imageView: UIImageView)
    {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
    }
    
    private func setUpLoginNameLabel(loginNameLabel: UILabel, nameLabel: UILabel)
    {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        loginNameLabel.text = "@ekaterina_nov"
    }
    
    private func setUpDescriptionLabel(descriptionLabel: UILabel, loginNameLabel: UILabel)
    {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setUpLogoutButton(logoutButton: UIButton)
    {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setupBackgroundColor(vc: UIViewController) {
        vc.view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        imageView.kf.setImage(with: url, options: [.processor(RoundCornerImageProcessor.init(cornerRadius: 61))])
    }
}
